import os
import logging
import tempfile
import shutil
from moviepy.editor import VideoFileClip
from PIL import Image

# Importações para processamento de vídeo
try:
    from moviepy.editor import VideoFileClip
    MOVIEPY_AVAILABLE = True
except ImportError:
    MOVIEPY_AVAILABLE = False
    logging.warning("MoviePy não disponível. Recorte automático de vídeo desabilitado.")

try:
    import imageio_ffmpeg
    FFMPEG_AVAILABLE = True
except ImportError:
    FFMPEG_AVAILABLE = False
    logging.warning("FFmpeg não disponível. Processamento de vídeo desabilitado.")

logger = logging.getLogger(__name__)

async def download_video(bot, file_id, temp_dir):
    """Baixa o vídeo do Telegram para processamento"""
    try:
        file = await bot.get_file(file_id)
        video_path = os.path.join(temp_dir, f"video_{file_id}.mp4")
        await file.download_to_drive(video_path)
        return video_path
    except Exception as e:
        logger.error(f"Erro ao baixar vídeo: {e}")
        return None

def crop_video_to_square(input_path, output_path=None, target_size=240):
    """
    Recorta um vídeo para formato quadrado e redimensiona para o tamanho especificado.
    Versão melhorada com tratamento de erros e otimizações.
    """
    if not os.path.exists(input_path):
        logger.error(f"Arquivo de entrada não encontrado: {input_path}")
        return None

    try:
        logger.info(f"🎬 Processando vídeo: {input_path}")
        
        with VideoFileClip(input_path) as video:
            width, height = video.size
            logger.info(f"📏 Original: {width}x{height}")
            
            # Calcular área de recorte
            crop_size = min(width, height)
            x_offset = (width - crop_size) // 2
            y_offset = (height - crop_size) // 2
            
            logger.info(f"✂️ Recortando: {crop_size}x{crop_size} em ({x_offset}, {y_offset})")
            
            # Recortar e redimensionar
            cropped = video.crop(
                x1=x_offset, y1=y_offset,
                x2=x_offset + crop_size, y2=y_offset + crop_size
            ).resize((target_size, target_size))
            
            # Configurar saída
            if not output_path:
                temp_dir = tempfile.gettempdir()
                output_path = os.path.join(temp_dir, f"processed_{os.path.basename(input_path)}")
            
            # Configurações otimizadas para Telegram
            output_params = {
                'codec': 'libx264',
                'audio_codec': 'aac',
                'bitrate': '500k',
                'preset': 'fast',
                'threads': 2,
                'ffmpeg_params': [
                    '-movflags', 'faststart'
                ]
            }
            
            if not cropped.audio:
                output_params.pop('audio_codec')
            
            logger.info(f"💾 Salvando: {output_path}")
            cropped.write_videofile(output_path, **output_params)
            
        return output_path
        
    except Exception as e:
        logger.error(f"❌ Erro no processamento: {str(e)}")
        logger.error(traceback.format_exc())
        return None

def cleanup_temp_files(temp_dir):
    try:
        if os.path.exists(temp_dir):
            shutil.rmtree(temp_dir)
            logger.info(f"Limpeza de temporários: {temp_dir}")
    except Exception as e:
        logger.error(f"Erro ao limpar temporários: {e}")


def check_disk_space(min_space=100):  # 100MB
    stat = shutil.diskusage(tempfile.gettempdir())
    return stat.free > (min_space * 1024 * 1024)
    
async def process_video_for_videonote(bot, file_id, temp_dir):
    """Processa vídeo para formato video_note"""
    try:
        # Baixar o vídeo
        input_path = await download_video(bot, file_id, temp_dir)
        if not input_path:
            return None, "Erro ao baixar vídeo"
        
        # Criar arquivo de saída
        output_path = os.path.join(temp_dir, f"processed_{file_id}.mp4")
        
        # Processar o vídeo
        result = crop_video_to_square(input_path, output_path)
        
        if result:
            return result, f"Vídeo recortado: {input_path}"
        else:
            return None, "Erro ao processar vídeo"
            
    except Exception as e:
        logger.error(f"Erro ao processar vídeo: {e}")
        return None, f"Erro no processamento: {str(e)}"

def process_video_for_telegram(input_path, output_path=None):
    """
    Processa um vídeo para ser compatível com video_note do Telegram.
    
    Args:
        input_path (str): Caminho do vídeo de entrada
        output_path (str): Caminho do vídeo de saída (opcional)
    
    Returns:
        str: Caminho do vídeo processado ou None se houver erro
    """
    try:
        logger.info(f"📱 Processando vídeo para Telegram video_note")
        
        # Verificar se o vídeo já é quadrado
        video = VideoFileClip(input_path)
        width, height = video.size
        
        if width == height:
            logger.info("✅ Vídeo já é quadrado, não precisa de recorte")
            video.close()
            return input_path
        
        # Recortar e redimensionar para 240x240 (tamanho recomendado para video_note)
        result = crop_video_to_square(input_path, output_path, target_size=240)
        
        if result:
            logger.info("✅ Vídeo processado para formato video_note")
            return result
        else:
            logger.error("❌ Falha ao processar vídeo")
            return None
            
    except Exception as e:
        logger.error(f"❌ Erro ao processar vídeo para Telegram: {e}")
        return None

def validate_video_for_telegram(input_path):
    """
    Valida se um vídeo é compatível com video_note do Telegram.
    
    Args:
        input_path (str): Caminho do vídeo
    
    Returns:
        dict: Dicionário com informações de validação
    """
    try:
        video = VideoFileClip(input_path)
        
        # Obter informações do vídeo
        width, height = video.size
        duration = video.duration
        fps = video.fps
        
        # Verificar requisitos do Telegram
        is_square = width == height
        is_duration_ok = duration <= 60  # Máximo 60 segundos
        is_size_ok = width >= 240 and height >= 240  # Mínimo 240x240
        
        # Calcular tamanho do arquivo (aproximado)
        file_size_mb = os.path.getsize(input_path) / (1024 * 1024)
        is_file_size_ok = file_size_mb <= 8  # Máximo 8MB
        
        video.close()
        
        validation_result = {
            'is_valid': is_square and is_duration_ok and is_size_ok and is_file_size_ok,
            'is_square': is_square,
            'is_duration_ok': is_duration_ok,
            'is_size_ok': is_size_ok,
            'is_file_size_ok': is_file_size_ok,
            'width': width,
            'height': height,
            'duration': duration,
            'file_size_mb': file_size_mb,
            'issues': []
        }
        
        # Listar problemas encontrados
        if not is_square:
            validation_result['issues'].append("Vídeo não é quadrado")
        if not is_duration_ok:
            validation_result['issues'].append("Duração maior que 60 segundos")
        if not is_size_ok:
            validation_result['issues'].append("Dimensões menores que 240x240")
        if not is_file_size_ok:
            validation_result['issues'].append("Arquivo maior que 8MB")
        
        return validation_result
        
    except Exception as e:
        logger.error(f"❌ Erro ao validar vídeo: {e}")
        return {
            'is_valid': False,
            'error': str(e),
            'issues': [f"Erro na validação: {e}"]
        } 