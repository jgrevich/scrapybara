Feature: scraper downloads daily index to disk

  In order to increase responsiveness and minimize bandwidth
  Scraper should download the index file do disk
  
  Scenario: scraper downloads index
    Given a scraper
    When I ask it to download the index
    Then I should see "Test"