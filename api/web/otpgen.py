## 2FA en python
## - generar secret key y con eso generar código

# pyotp
import pyotp
import qrcode
import io
import base64

def gen_otp(username, key):
    uri = pyotp.TOTP(key).provisioning_uri(name=username, issuer_name="GymApp")
    
    buffer = io.BytesIO()
    qrcode.make(uri).save(buffer, format="PNG") # guardarlo en memoria para no tener imagen física
    buffer.seek(0)
    qr_base64 = base64.b64encode(buffer.read()).decode()
    
    return qr_base64

def verificar_otp(key, input_code):
    return pyotp.TOTP(key).verify(input_code)
