Feature:  Web Scrapper
 
  Scenario: 1
    Given I connect to http://www.worten.pt
    When I search a product "ELECTRONIC ARTS"
    Then the product search result should include "Jogo Xbox One FIFA 22"
    And the product description should exist with
    |description|
    |CONMBOL    |

  Scenario: 2
    Given I connect to http://www.worten.pt
    When I search a product "PS4 FIFA 22"
    Then the product search result should include "Jogo PS4 FIFA 22"
    And the product characteristics should exist with
    |Referência|EAN          |Género  |Idioma|
    |7413425   |5030943123776|Desporto|Inglês|

  Scenario: 3
    Given I connect to http://www.worten.pt
    When I search a product "PS4 FIFA 22"
    Then the product search result should include "Jogo PS4 FIFA 22"
    And the product oldest comment should be 3 months or older
    And the product ratings should exist with
    |2 stars|
    |0      |
   
  Scenario: 4
    Given I connect to http://www.worten.pt
    When I search a product "PS4 FIFA 22"
    Then the product search result should include "Jogo PS4 FIFA 22"
    Then the product stock should exist with
    |Mar Shopping|
    |Em stock    |

  Scenario: 5
    Given I connect to http://www.worten.pt
    When I search a product "PS4 FIFA 22"
    Then the product search result should include "Jogo PS4 FIFA 22"
    When I add the product to the cart
    Then cart should have 1 item
    And the cart total value should be valid
   
  Scenario: 6
    Given I connect to http://www.worten.pt
    When I search a store "lisboa"
    Then the store search result should include "Centro Comercial Vasco da Gama"
    And the store details should exist with
    |Coordenadas          |Horário                     |
    |38.768485 - -9.097495|Todos os dias: 09:00 - 00:00|