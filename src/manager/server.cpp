#include "server.h"
#include "clientsocket.h"

Server::Server(QObject *parent)
    : QTcpServer(parent)
{
}

void Server::incomingConnection(int socketId)
{
    ClientSocket *socket = new ClientSocket(this);
    socket->setSocketDescriptor(socketId);
}
