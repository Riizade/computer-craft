from __future__ import annotations
import requests
import os
from lxml import etree as XMLTree
from typing import Dict, Optional, List
from dataclasses import dataclass
import pathlib
from urllib.parse import quote_plus as urlencode

@dataclass(frozen=True)
class PastebinItem:
    paste_key: str
    paste_date: int
    paste_title: str
    paste_size: int
    paste_expire_date: int
    paste_private: int
    paste_format_long: Optional[str]
    paste_format_short: str
    paste_url: str
    paste_hits: int

    @classmethod
    def from_xml_node(node) -> PastebinItem:
        return PastebinItem(
            paste_key=node.find("paste_key"),
            paste_date=int(node.find("paste_date")),
            paste_title=node.find("paste_title"),
            paste_size=int(node.find("paste_expire_date")),
            paste_private=int(node.find("paste_private")),
            paste_format_long=node.find("paste_format_long"),
            paste_format_short=node.find("paste_format_short"),
            paste_url=node.find("paste_url"),
            paste_hits=int(node.find("paste_hits")),
        )

def get_pastes() -> List[PastebinItem]:
    api_key = os.environ['PASTEBIN_API_KEY']
    user_key = os.environ['PASTEBIN_API_USER_KEY']

    response = requests.post('https://pastebin.com/', data={
        'api_dev_key': api_key,
        'api_user_key': user_key,
        'api_option': 'list',
        'api_results_limit': 100,
    })

    if response.status_code != 200:
        raise RuntimeError(f"Bad response from pastebin: {response.text}")

    current_node = XMLTree.fromstring(response.text)
    nodes = []
    while current_node is not None:
        nodes.append(current_node)
        current_node = current_node.getnext()

    return [PastebinItem.from_xml_node(node) for node in nodes]


# creates a session, saves the created session token as an environment variable, and returns it as a string
def create_session() -> str:
    api_key = os.environ['PASTEBIN_API_KEY']
    username = os.environ['PASTEBIN_USERNAME']
    password = os.environ['PASTEBIN_PASSWORD']

    response = requests.post(url="https://pastebin.com/a", data={
        'api_dev_key': api_key,
        'api_user_name': username,
        'api_user_password': password,
    })

    if response.status_code != 200:
        raise RuntimeError(f"Bad response from pastebin: {response.text}")

    user_key = response.text

    os.environ['PASTEBIN_API_USER_KEY'] = user_key

    return user_key


# returns a Dict from title -> key
def get_paste_keys() -> Dict[str, str]:
    pastes = get_pastes()
    keys = {}
    for paste in pastes:
        keys[paste.paste_title] = paste.paste_key

    return keys

# returns Dict from file stem -> contents
def read_files() -> Dict[str, str]:
    lua_contents = {}
    lua_dir = pathlib.Path(__file__).parent / "../lua/"
    for child in lua_dir.iterdir():
        if child.is_file() and child.suffix == ".lua":
            with open(child) as f:
                lua_contents[child.stem] = f.read()
    return lua_contents

def get_computercraft_keys() -> Dict[str, str]:
    cc_keys = {}
    for title, key in get_paste_keys().items():
        if title.startswith("computer-craft/"):
            cc_keys[title] = key
    return cc_keys

# returns the paste id
def create_new_paste(title: str, contents: str) -> str:
    api_key = os.environ['PASTEBIN_API_KEY']
    user_key = os.environ['PASTEBIN_API_USER_KEY']

    response = requests.post('https://pastebin.com/api/api_post.php', data={
        'api_dev_key': api_key,
        'api_paste_code': urlencode(contents),
        'api_paste_name': urlencode(f"computer-craft/{title}"),
        'api_paste_expire_date': 'N',
        'api_paste_format': 'lua',
        'api_user_key': user_key,
    })

    if response.status_code != 200:
        raise RuntimeError(f"Bad response from pastebin: {response.text}")


def update_existing_paste(title: str, contents: str, paste_key: str):
    pass

def delete_paste(paste_key: str):
    api_key = os.environ['PASTEBIN_API_KEY']
    user_key = os.environ['PASTEBIN_API_USER_KEY']
    response = requests.post('https://pastebin.com/api/api_post.php', data={
        'api_dev_key': api_key,
        'api_user_key': user_key,
        'api_option': 'delete',
        'api_paste_key': paste_key,
    })

    if response.status_code != 200:
        raise RuntimeError(f"Bad response from pastebin: {response.text}")
"""
$api_dev_key 			= 'v-GgBAlf2V0wV2qdiFGrdWfXqgH3ENcu'; // your api_developer_key
$api_paste_code 		= 'just some random text you :)'; // your paste text
$api_paste_private 		= '1'; // 0=public 1=unlisted 2=private
$api_paste_name			= 'justmyfilename.php'; // name or title of your paste
$api_paste_expire_date 		= '10M';
$api_paste_format 		= 'php';
$api_user_key 			= ''; // if an invalid or expired api_user_key is used, an error will spawn. If no api_user_key is used, a guest paste will be created
$api_paste_name			= urlencode($api_paste_name);
$api_paste_code			= urlencode($api_paste_code);

$url 				= 'https://pastebin.com/api/api_post.php';
$ch 				= curl_init($url);
"""

def upload_files():
    create_session()
    lua_files = read_files()
    pastebin_files = get_computercraft_keys()

    for filename, contents in lua_files.items():
        if




