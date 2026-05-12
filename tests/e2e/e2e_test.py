from selenium import webdriver
from selenium.webdriver.common.by import By
from selenium.webdriver.chrome.options import Options
from selenium.webdriver.chrome.service import Service
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC

def test_e2e():
    URL = "http://peps-web:80"

    options = Options()
    options.add_argument("--headless=new")
    options.add_argument("--no-sandbox")
    options.add_argument("--disable-dev-shm-usage")

    driver = webdriver.Chrome(
        service=Service('/usr/bin/chromedriver'),
        options=options
    )

    wait = WebDriverWait(driver, 10)

    try:
        driver.get(URL)

        wait.until(
            EC.element_to_be_clickable((By.XPATH, "//button[contains(text(),'Crear cuenta')]"))
        ).click()

        username = wait.until(
            EC.element_to_be_clickable((By.ID, "username_register"))
        )
        username.send_keys("testuser")

        driver.find_element(By.ID, "password_register").send_keys("testpass")
        driver.find_element(
            By.XPATH, "//button[contains(text(),'Registrarse')]"
        ).click()

        wait.until(
            EC.element_to_be_clickable((By.ID, "username"))
        ).send_keys("testuser")

        driver.find_element(By.ID, "password").send_keys("testpass")
        driver.find_element(
            By.XPATH, "//button[contains(text(),'Entrar')]"
        ).click()

    finally:
        driver.quit()