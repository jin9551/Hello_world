# 이메일 메시지에 다양한 형식을 중첩하여 담기 위한 객체
from email.mime.multipart import MIMEMultipart

# 이메일 메시지를 이진 데이터로 바꿔주는 인코더
from email import encoders

# 텍스트 형식
from email.mime.text import MIMEText
# 이미지 형식
from email.mime.image import MIMEImage
# 오디오 형식
from email.mime.audio import MIMEAudio

# 위의 모든 객체들을 생성할 수 있는 기본 객체
# MIMEBase(_maintype, _subtype)
# MIMEBase(<메인 타입>, <서브 타입>)
from email.mime.base import MIMEBase

msg_dict = {
  'text' : {'maintype' : 'text', 'subtype' :'plain', 'filename' : 'test.txt'}, # 텍스트 첨부파일
  'image' : {'maintype' : 'image', 'subtype' :'jpg', 'filename' : 'test.jpg' }, # 이미지 첨부파일
  'audio' : {'maintype' : 'audio', 'subtype' :'mp3', 'filename' : 'test.mp3' }, # 오디오 첨부파일
  'video' : {'maintype' : 'video', 'subtype' :'mp4', 'filename' : 'test.mp4' }, # 비디오 첨부파일
  'application' : {'maintype' : 'application', 'subtype' : 'octect-stream', 'filename' : 'test.pdf'} # 그외 첨부파일
}

def make_multimsg(msg_dict):
    multi = MIMEMultipart(_subtype='mixed')
    
    for key, value in msg_dict.items():
        # 각 타입에 적절한 MIMExxx()함수를 호출하여 msg 객체를 생성한다.
        if key == 'text':
            with open(value['filename'], encoding='utf-8') as fp:
                msg = MIMEText(fp.read(), _subtype=value['subtype'])
        elif key == 'image':
            with open(value['filename'], 'rb') as fp:
                msg = MIMEImage(fp.read(), _subtype=value['subtype'])
        elif key == 'audio':
            with open(value['filename'], 'rb') as fp:
                msg = MIMEAudio(fp.read(), _subtype=value['subtype'])
        else:
            with open(value['filename'], 'rb') as fp:
                msg = MIMEBase(value['maintype'],  _subtype=value['subtype'])
                msg.set_payload(fp.read())
                encoders.encode_base64(msg)
        # 파일 이름을 첨부파일 제목으로 추가
        msg.add_header('Content-Disposition', 'attachment', filename=value['filename'])

        # 첨부파일 추가
        multi.attach(msg)
    
    return multi