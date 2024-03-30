#!/usr/bin/env python3
# pip install undetected-chromedriver==3.5.5 webdriver-manager
# sudo apt-get install xdotool
# run: xdotool getmouselocation --shell

import time, os, requests, json
from selenium import webdriver
from selenium.webdriver.common.keys import Keys
from selenium.webdriver.common.by import By
from selenium.webdriver.common.action_chains import ActionChains
from selenium.webdriver.support.wait import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC
import undetected_chromedriver as uc

username = 'username'
password = 'password'

current_path = os.getcwd()
image_dir    = os.path.join(current_path, 'images')

# download image before run web automation
exit_code = 0 #os.system(os.path.join(current_path, 'webdriver', 'get_images.rb'))
os.chdir(image_dir)

def write_error_file(id):
  with open(os.path.join(current_path, 'error_ids_cached.txt'), 'a') as cache:
    cache.write(str(id) + '\n')

def write_on_success_file(id):
  with open(os.path.join(current_path, 'success_ids.txt'), 'a') as cache:
    cache.write(str(id) + '\n')

if exit_code == 0:
  driver = uc.Chrome()
  driver.maximize_window()

  url = "https://www.bling.com.br"
  driver.get(url)

  time.sleep(1)

  element_to_hover_over = WebDriverWait(driver, 10).until(
    EC.presence_of_element_located((By.ID, "dropdown"))
  )

  action_chains = ActionChains(driver)
  action_chains.move_to_element(element_to_hover_over).perform()

  time.sleep(1)

  username_input = WebDriverWait(driver, 10).until(
    EC.presence_of_element_located((By.ID, "username"))
  )
  password_input = WebDriverWait(driver, 10).until(
    EC.presence_of_element_located((By.ID, "senha"))
  )

  login_button = WebDriverWait(driver, 10).until(
    EC.element_to_be_clickable((By.CSS_SELECTOR, '[name="enviar-dropdown"]'))
  )

  username_input.send_keys(username)
  password_input.send_keys(password)

  time.sleep(1)

  login_button.click()

  time.sleep(2)

  jpg_files = sorted([file for file in os.listdir(image_dir) if file.lower().endswith((".jpg", ".jpeg", ".png"))])

  for file in jpg_files:
    product_id = file.lower().split("-id")[0]
    print(f'\nID do produto {product_id}')

    product_edit_url = 'https://www.bling.com.br/produtos.php#edit/' + str(product_id)
    driver.get(product_edit_url)
    
    time.sleep(4)
    
    modal = WebDriverWait(driver, 10).until(
      EC.presence_of_element_located((By.CLASS_NAME, 'ui-dialog'))
    )

    time.sleep(3)

    tab_name = "div_imagens"
    tab_xpath = f'//ul[@class="bling-tabs"]/li[@data-tab="div_imagens"]/a'
    tab_element = WebDriverWait(modal, 10).until(
      EC.element_to_be_clickable((By.XPATH, tab_xpath))
    )

    tab_element.click()
    
    time.sleep(2)

    js_script = '''
    var uploadButton = document.querySelector('.qq-upload-button-dashed');
    uploadButton.click();
    '''

    driver.execute_script(js_script)

    time.sleep(2)

    file_input = driver.find_element(By.CLASS_NAME, 'qq-file-input')
    
    image_path = os.path.join(image_dir, file)
    driver.execute_script("arguments[0].style.display='block';", file_input)
    file_input.send_keys(image_path)

    time.sleep(5)

    upload_modal = driver.find_element(By.CSS_SELECTOR, '.ui-draggable.ui-dialog-newest')

    upload_modal.send_keys(Keys.ESCAPE)

    time.sleep(2)

    save_button = driver.find_element(By.CSS_SELECTOR, '.Button.Button--primary.ui-button')

    save_button.send_keys(Keys.ENTER)
    
    time.sleep(2)

    try:
      save_button = WebDriverWait(driver, 10).until(
        EC.presence_of_element_located((By.ID, 'botaoSalvar'))
      )

      save_button.click()
      print('\nProduto id', product_id, 'salvo com sucesso!')
    except:
      write_error_file(product_id)
      os.remove(os.path.join(image_dir, file))

    time.sleep(3)

    url = "https://www.bling.com.br"
    driver.get(url)

    time.sleep(2)
    os.remove(os.path.join(image_dir, file))

  driver.quit()
else:
  exit(1)
