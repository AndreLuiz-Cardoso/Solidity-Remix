// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

// Módulo 02 > Lição 04 > Tóps 03 e 05 - JoKenPo com Aposta
contract JoKenPo {

    enum Options { NONE, ROCK, PAPER, SCISSORS } // 0, 1, 2, 3

    Options private choice1 = Options.NONE;
    address private player1;
    string public result = "";

    address payable private immutable owner;

    struct Player {
        address wallet;
        uint32 wins;
    }

    Player[] public players;

    constructor() {
        owner = payable(msg.sender);
    }

    function updateWinner(address winner) private {
        for (uint i = 0; i < players.length; i++) {
            if (players[i].wallet == winner) {
                players[i].wins++;
                return;
            }
        }
        players.push(Player(winner, 1));
    }

    function finishGame(string memory newResult, address winner) private {
        address contractAddress = address(this);

        // 90% para o vencedor, restante para o owner (10%)
        payable(winner).transfer((contractAddress.balance / 100) * 90);
        owner.transfer(contractAddress.balance);

        updateWinner(winner);

        // reset de estado e mensagem
        result = newResult;
        player1 = address(0);
        choice1 = Options.NONE;
    }

    function getBalance() public view returns (uint) {
        require(owner == msg.sender, "You don't have this permission.");
        return address(this).balance;
    }

    function play(Options newChoice) public payable {
        require(newChoice != Options.NONE, "Invalid choice");
        require(player1 != msg.sender, "Wait the another player.");
        require(msg.value >= 0.01 ether, "Invalid bid.");

        if (choice1 == Options.NONE) {
            player1 = msg.sender;
            choice1 = newChoice;
            result = "Player 1 choose his/her option. Waiting player 2.";
        }
        else if (choice1 == Options.ROCK && newChoice == Options.SCISSORS)
            finishGame("Rock breaks scissors. Player 1 won.", player1);
        else if (choice1 == Options.PAPER && newChoice == Options.ROCK)
            finishGame("Paper wraps rock. Player 1 won.", player1);
        else if (choice1 == Options.SCISSORS && newChoice == Options.PAPER)
            finishGame("Scissors cuts paper. Player 1 won.", player1);
        else if (choice1 == Options.SCISSORS && newChoice == Options.ROCK)
            finishGame("Rock breaks scissors. Player 2 won.", msg.sender);
        else if (choice1 == Options.ROCK && newChoice == Options.PAPER)
            finishGame("Paper wraps rock. Player 2 won.", msg.sender);
        else if (choice1 == Options.PAPER && newChoice == Options.SCISSORS)
            finishGame("Scissors cuts paper. Player 2 won.", msg.sender);
        else {
            // Empate: saldo fica no contrato (acumula para a próxima)
            result = "Draw game. The prize was doubled.";
            player1 = address(0);
            choice1 = Options.NONE;
        }
    }

    function getLeaderboard() public view returns (Player[] memory) {
        uint len = players.length;
        if (len < 2) return players;

        // copia de storage para memória
        Player[] memory arr = new Player[](len);
        for (uint i = 0; i < len; i++) {
            arr[i] = players[i];
        }

        // ordena por wins (desc)
        for (uint i = 0; i < len; i++) {
            for (uint j = i + 1; j < len; j++) {
                if (arr[i].wins < arr[j].wins) {
                    Player memory tmp = arr[i];
                    arr[i] = arr[j];
                    arr[j] = tmp;
                }
            }
        }
        return arr;
    }
}
