# challenge

This is a cucumber project for web automation.
The underlying code was done using Ruby as it is the language I am most familiar with and because it has available a wide array of toolkits for most tasks. In this case, for web interaction and scrapping the Selenium based Watir toolkit and the Nokogiri gems were used.

### Installations and pre-requisites
- [Ruby](https://rubyinstaller.org/downloads) (get the recommended version - used 3.1.1)
- [Google Chrome](https://www.google.com/chrome/) (get the recommended version)
- [Chromedriver](https://chromedriver.chromium.org/downloads) (get the version accordingly to the chrome version installed previously)\
Unzip and get 'chromedriver.exe' into the bin folder of you ruby installation

### Get the project going
- Copy the project to your PC
- Run 'gem install bundler' to update the bundler
- In the project main directory run 'bundle install' to get the needed gems

### Run the test automation

```bash
cucumber .\features\web_scrapper.feature --format html --out test_run.html
```

HTML file report test_run.html is generated in the main directory