import processing.net.*;

Server server;
Client client;

String role = ""; // "client" or "server"
String inputText = "";
ArrayList<String> messages = new ArrayList<String>();
boolean connected = false;
String serverIP = "localhost";
int port = 1337;

void clientEvent(Client c) {
  String msg = c.readString();
  if (msg != null) {
    msg = msg.trim();
    println("Получено: " + msg);
    messages.add("Сервер: " + msg);
  }
}

void serverEvent(Server s, Client c) {
  println("Клиент подключён: " + c.ip());
  client = c; // Двусторонняя связь — сохраняем клиента как `client`
  connected = true;
}

void serialEvent(Client c) {
  String msg = c.readStringUntil('\n');
  if (msg != null) {
    msg = msg.trim();
    messages.add("Другой: " + msg);
    println("Клиент отправил: " + msg);
  }
}

void checkConnection() {
  if (role.equals("client") && client != null && client.active()) {
    connected = true;
  }
  
  if (role.equals("server") && client != null) {
    connected = true;
  }
}
