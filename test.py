from urllib.request import urlopen

URL = 'http://localhost:8080/components/1'

for i in range(1000):
    try:
        with urlopen(URL) as response:
            html = response.read()
            print(html.decode('utf-8'))
    except Exception as e:
        print(f"An error occurred: {e}")
