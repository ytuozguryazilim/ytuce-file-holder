import requests
import os
import re

#CONSTANTS
PERSONS_URL = "https://www.ce.yildiz.edu.tr/subsites"
PERSON_LIST_SELECTOR = ["<ul id=\"userarray\" class=\"subsites\">","</ul>"]

#FIlE OPERATIONS
def create_folder(folder_name):
	os.makedirs(folder_name)

def is_folder_exist(folder_name):
	return os.path.exists(folder_name) and os.path.isdir(folder_name)

def save_data_to_file(data,folder_name,file_name):
	if(folder_name[len(folder_name)-1] != '/' and file_name[0] != '/'):
		folder_name += '/'
	if(not is_folder_exist(folder_name)):
		create_folder(folder_name)
	save_path = folder_name+file_name
	file_write = open(save_path,"w")
	print(data,file=file_write)
	file_write.close()
#REQUEST OPERATIONS
def get_page_by_url(url):
	req = requests.get(url,verify=False)
	return req.text

#GENERAL OPERATIONS
def persons_crawler():
	persons_page = get_page_by_url(PERSONS_URL)
	persons_list = persons_page.split(PERSON_LIST_SELECTOR[0])[1].split(PERSON_LIST_SELECTOR[1])[0]
	persons = re.findall("<a href=\"(.*)\">",persons_list)
	return persons

print(persons_crawler())