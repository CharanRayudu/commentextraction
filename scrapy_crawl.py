import scrapy
import re

class CommentsSpider(scrapy.Spider):
    name = 'comments'
    start_urls = []

    # Read the list of websites from a file
    with open('websites.txt', 'r') as file:
        start_urls = file.read().splitlines()

    def parse(self, response):
        # Extract comments from the HTML source code
        html_comments = self.extract_comments(response.text)

        # Extract comments from JavaScript code
        js_comments = self.extract_js_comments(response.text)

        # Combine HTML and JavaScript comments
        all_comments = html_comments + js_comments

        # Save comments to a file
        with open('comments_output.txt', 'a', encoding='utf-8') as file:
            file.write(f"URL: {response.url}\n")
            if all_comments:
                for comment in all_comments:
                    file.write(f"{comment}\n")
            else:
                file.write("No comments found.\n")
            file.write("\n" * 3 + "////////\n")

    def extract_comments(self, text):
        comment_pattern = r"<!--(.*?)-->"
        comments = re.findall(comment_pattern, text, re.DOTALL)
        return comments

    def extract_js_comments(self, text):
        js_comment_pattern = r"/\*(.*?)\*/"
        js_comments = re.findall(js_comment_pattern, text, re.DOTALL)
        return js_comments


# Run the spider
from scrapy.crawler import CrawlerProcess

process = CrawlerProcess({
    'USER_AGENT': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/58.0.3029.110 Safari/537.36',
})

process.crawl(CommentsSpider)
process.start()