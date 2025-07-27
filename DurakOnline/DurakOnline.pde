// Карты в руках игроков
ArrayList<Card> player1 = new ArrayList<Card>();
ArrayList<Card> player2 = new ArrayList<Card>();
// test
ArrayList<Card> beatedCards = new ArrayList<Card>(); // Битые кары
ArrayList<Card> tableCards = new ArrayList<Card>(); // Карты на столе

// Перемешанная колода
  ArrayList<Card> shuffleDeck(ArrayList<Card> d) {
    ArrayList<Card> newDeck = new ArrayList<Card>();
    while (d.size() > 0) {
      int index = int(random(d.size()));
      newDeck.add(d.remove(index));
    }
    return newDeck;
  }

Card trump; // Козырь
int currentPlayer = 1;
int currentAttacker = 1;
int winner = 0; // 0 - никто, 1 - игрок 1, 2 - игрок 2
int gameState = 0;

void setup() {
  size(1000, 600);
  textAlign(CENTER, CENTER);
  font = createFont("Arial Unicode MS", 48);
  
  createDeck();
  
  deck = shuffleDeck(deck);
  trump = deck.get(deck.size() - 1); // Выбираем козырь (последняя карта из колоды)
  
  // Раздаём карты игрокам
  for (int i = 0; i < 6; i++) {
    player1.add(deck.remove(0)); // Добавляем карту игроку, удаляем её из колоды
    player2.add(deck.remove(0));
  }
  
  println("Карты игрока 1:");
  for (Card c : player1) c.showCards();
  println(" ");
  println("Карты игрока 2:");
  for (Card c : player2) c.showCards();
  
  if (role.equals("server")) {
    server = new Server(this, port);
    println("Сервер запущен. Ожидаем игрока...");
  } else if (role.equals("client")) {
    client = new Client(this, "localhost", port); // Используем localhost для теста
    println("Пытаемся подключиться к серверу...");
  }
}

void draw() {
  background(50, 110, 70);
  
  switch(gameState) {
    case 0: mainMenu(); checkConnection(); break;
    case 1: Durak(); break;
  }
  
  if (connected && role.equals("client") && client.available() > 0) {
    String msg = client.readStringUntil('\n');
    if (msg != null) {
      msg = msg.trim();
      messages.add("Сервер: " + msg);
      println("Получено от сервера: " + msg);
    }
  }
  
  if (connected && role.equals("server") && client != null && client.available() > 0) {
    String msg = client.readStringUntil('\n');
    if (msg != null) {
      msg = msg.trim();
      messages.add("Клиент: " + msg);
      println("Получено от клиента: " + msg);
    }
  }
  
  if (connected) {
    fill(0, 255, 0);
    text("Подключено!", 70, 20);
  } else {
    fill(255, 0, 0);
    text("Не подключено", 70, 20);
  }
}

void Durak() {
  background(50, 110, 70);
  drawPlayerCards(player1, height - 140, currentPlayer == 1);
  drawPlayerCards(player2, 50, currentPlayer == 2);
  drawTableCard(50);
  drawButtons();
  checkWinner();
  hoveredCard = getCardAtMouse(currentPlayer == 1 ? player1 : player2, currentPlayer == 1 ? height - 140 : 50);
  
  //println("currentPlayer" + currentPlayer);
  //println("currentAttacker" + currentAttacker);
}

void mousePressed() {
  if (winner != 0) return; // Игра уже закончена
  
  // АТАКА ИГРОКА 1
  if (currentPlayer == 1 && currentAttacker == 1 && tableCards.size() % 2 == 0) {
    Card clicked = getCardAtMouse(player1, height - 140);
    if (clicked != null && (tableCards.size() == 0 || getTableRanks().contains(clicked.rank))) {
      tableCards.add(clicked);
      player1.remove(clicked);
      currentPlayer = 2;
    }
  }
  
  // ОТБОЙ ИГРОКА 2
  else if (currentPlayer == 2 && currentAttacker == 1 && tableCards.size() % 2 == 1) {
    Card lastAttackCard = tableCards.get(tableCards.size() - 1);
    Card clicked = getCardAtMouse(player2, 50);
    if (clicked != null && canBeat(lastAttackCard, clicked)) {
      tableCards.add(clicked);
      player2.remove(clicked);
      currentPlayer = 1;
    }
  }
  
  // АТАКА ИГРОКА 2
  else if (currentPlayer == 2 && currentAttacker == 2 && tableCards.size() % 2 == 0) {
    Card clicked = getCardAtMouse(player2, 50);
    if (clicked != null && (tableCards.size() == 0 || getTableRanks().contains(clicked.rank))) {
      tableCards.add(clicked);
      player2.remove(clicked);
      currentPlayer = 1;
    }
  }
  
  // ОТБОЙ ИГРОКА 1
  else if (currentPlayer == 1 && currentAttacker == 2 && tableCards.size() % 2 == 1) {
    Card lastAttackCard = tableCards.get(tableCards.size() - 1);
    Card clicked = getCardAtMouse(player1, height - 140);
    if (clicked != null && canBeat(lastAttackCard, clicked)) {
      tableCards.add(clicked);
      player1.remove(clicked);
      currentPlayer = 2;
    }
  }
  
  // КНОПКА "ЗАБРАТЬ"
  if (mouseX > width / 2 - 50 && mouseX < width / 2 + 50 &&
      mouseY > height / 2 + 100 && mouseY < height / 2 + 140) {
    takeCards();
    drawCardsTo6();
    checkWinner();
  }

  // КНОПКА "БИТО"
  if (mouseX > width / 2 - 200 && mouseX < width / 2 - 100 &&
      mouseY > height / 2 + 100 && mouseY < height / 2 + 140) {
    beatCards();
    drawCardsTo6();
    checkWinner();
  }
}
