# This script is used to get the diff of tidb tags between pingcap and wangdi4zm
import os
import json
import re
import requests


DOCKERHUB_USERNAME = os.environ.get('DOCKERHUB_USERNAME')


def get_repo_tags_from_docker_hub(user:str, repo:str, page_size:int=100) -> set:
    # The maximum page_size accepted by docker hub is 100
    next_api = f'https://hub.docker.com/v2/repositories/{user}/{repo}/tags/?page_size={page_size}'
    requests_headers = {
        'Content-Type': 'application/json; charset=utf-8',
    }
    tags = []
    while next_api is not None:
        resp = requests.get(
            next_api,
            headers=requests_headers,
            timeout=3
        )
        if resp.status_code == 200:
            results = resp.json()['results']
            next_api = resp.json()['next']
            tags += [r['name'] for r in results]
        elif resp.status_code == 404:
            next_api = None
        else:
            raise Exception(f'Got unexpected status code: {resp.status_code}, content: {resp.content}')
    filtered_tags = []
    for tag in tags:
        tag = tag.lower()
        r = re.findall(r'^v(\d+)\.(\d+)\.(\d+)$', tag)
        if not r:
            continue
        filtered_tags.append(tag)
    return set(filtered_tags)

pingcap_tidb_tags = get_repo_tags_from_docker_hub('pingcap', 'tidb')
wangdi4zm_tidb_tags = get_repo_tags_from_docker_hub(DOCKERHUB_USERNAME, 'tind')
diff = list(filter(lambda x: x >= 'v5', pingcap_tidb_tags - wangdi4zm_tidb_tags))
print(f'DIFF_TAGS={json.dumps(diff)}')
