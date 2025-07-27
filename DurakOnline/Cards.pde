class Card {
  String suit;// Масть: "♠", "♥", "♣", "♦"
  int rank; // Ранг: 6 - 14
  
  Card(String Suit, int Rank) {
    this.suit = Suit;
    this.rank = Rank;
  }
  
  // Показываем в консоль карты игрока
  void showCards() {
    println(suit + " " + rank);
  }
}

// Колода
ArrayList<Card> deck = new ArrayList<Card>();

boolean canBeat(Card attack, Card defend) {
  if (defend.suit.equals(attack.suit) && defend.rank > attack.rank) {
    return true;
  }
  if (!defend.suit.equals(attack.suit) && defend.suit.equals(trump.suit)) {
    return true;
  }
  return false;
}

ArrayList<Integer> getTableRanks() {
  ArrayList<Integer> ranks = new ArrayList<Integer>();
  for (Card c : tableCards) {
    if (!ranks.contains(c.rank)) {
      ranks.add(c.rank);
    }
  }
  return ranks;
}

void drawCardsTo6() {
  while (player1.size() < 6 && deck.size() > 0) {
    player1.add(deck.remove(0));
  }
  while (player2.size() < 6 && deck.size() > 0) {
    player2.add(deck.remove(0));
  }
}

void checkWinner() {
  if (player1.isEmpty() && deck.isEmpty()) {
    winner = 1;
    println("winner: " + winner);
  }
  if (player2.isEmpty() && deck.isEmpty()) {
    winner = 2;
    println("winner: " + winner);
  }
}

void createDeck() {
  String[] suits = {"Spades", "Hearts", "Clubs", "Diamonds"}; // Список всех мастей
  
  // Созание колоды
  for (String suit : suits) {
    for (int rank = 6; rank <= 14; rank++) {
      deck.add(new Card(suit, rank));
    }
  }
  
  deck = shuffleDeck(deck);
  trump = deck.get(deck.size() - 1); // Выбираем козырь (последняя карта из колоды)
}
