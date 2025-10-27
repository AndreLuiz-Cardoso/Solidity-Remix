# 🧱 Solidity Practice Projects – Remix & Foundry

> A collection of **Solidity smart contracts** built in **Remix IDE** to practice core Web3 concepts: ERC-20, vaults, on-chain games, CRUD, inheritance, and factory patterns.  
> Fully compatible with **Foundry** for local compilation, scripting, and testing.

---

## 🔗 Smart Contracts (clickable links)

- [`tokenization.sol` – LuxembourgGoldToken (gold-backed ERC-20)](https://github.com/AndreLuiz-Cardoso/Solidity-Remix/blob/main/tokenization.sol)  
- [`colchao.sol` – ERC-20 Vault (“mattress” vault)](https://github.com/AndreLuiz-Cardoso/Solidity-Remix/blob/main/colchao.sol)  
- [`StorageFactory.sol` – Factory for `SimpleStorage`](https://github.com/AndreLuiz-Cardoso/Solidity-Remix/blob/main/StorageFactory.sol)  
- [`SimpleStorage.sol` – Basic storage contract](https://github.com/AndreLuiz-Cardoso/Solidity-Remix/blob/main/SimpleStorage.sol)  
- [`ParOuImpar.sol` – Even or Odd PvP game](https://github.com/AndreLuiz-Cardoso/Solidity-Remix/blob/main/ParOuImpar.sol)  
- [`JoKenPo.sol` – Rock/Paper/Scissors with betting & leaderboard](https://github.com/AndreLuiz-Cardoso/Solidity-Remix/blob/main/JoKenPo.sol)  
- [`BookDatabase.sol` – On-chain book CRUD database](https://github.com/AndreLuiz-Cardoso/Solidity-Remix/blob/main/BookDatabase.sol)  
- [`AddFiveStorage.sol` – Inheritance/override example](https://github.com/AndreLuiz-Cardoso/Solidity-Remix/blob/main/AddFiveStorage.sol)

---

## 🗂️ Project Structure
contracts/
├─ AddFiveStorage.sol
├─ BookDatabase.sol
├─ JoKenPo.sol
├─ ParOuImpar.sol
├─ SimpleStorage.sol
├─ StorageFactory.sol
├─ colchao.sol
└─ tokenization.sol

---

## 🔍 Overview and Key Insights

### 1) `tokenization.sol` — **LuxembourgGoldToken (Gold-Backed ERC-20)**  
**Description:**  
ERC-20 token fully backed by physical gold stored in vaults.  
**Key Functions:**  
- `mint(to, amount)` — Owner-only mint when physical gold is deposited off-chain.  
- `burn(amount)` — Burns tokens when gold is redeemed.  
- `getGoldPerToken()` — Returns backing ratio (gold per token).  

**Security & Best Practices:**  
- Built on **OpenZeppelin** (`ERC20`, `Ownable`).  
- Requires **off-chain verification** (audits or oracle attestations).  
- Transparent reserve tracking via `totalGoldReserves`.  
- Suitable for **asset-backed tokenization** or **real-world asset (RWA)** use cases.

---

### 2) `colchao.sol` — **ERC-20 Vault (Safe Deposit Contract)**  
**Description:**  
Simple token vault allowing users to deposit and withdraw ERC-20 tokens.  
**Key Functions:**  
- `deposit(amount)` — Transfers tokens from user to contract.  
- `withdraw(amount)` — Sends tokens back to the user.  

**Security & Best Practices:**  
- Requires prior `approve()` from the user.  
- Could use **SafeERC20** for safety with non-standard tokens.  
- Add `Deposited` / `Withdrawn` events for transparency.  
- Optionally add `Pausable`, `ReentrancyGuard`, or withdrawal limits.

---

### 3) `StorageFactory.sol` — **Factory Pattern Example**  
**Description:**  
Creates and manages multiple instances of `SimpleStorage`.  
**Key Functions:**  
- `createSimpleStorageContract()` — Deploys new storage contracts.  
- `sfStore(index, value)` / `sfGet(index)` — Interacts with child contracts.  

**Insights:**  
- Demonstrates the **Factory design pattern**.  
- Could emit events when new contracts are deployed.  
- Great example of **contract-to-contract interaction**.

---

### 4) `SimpleStorage.sol` — **Basic Storage**  
**Description:**  
Stores and retrieves a number, and keeps a list of people with their favorite numbers.  
**Key Functions:**  
- `store(uint256)` — Sets the number (`virtual` for inheritance).  
- `retrieve()` — Returns the stored number.  
- `addPerson(name, number)` — Adds a person and maps their number.  

**Educational Purpose:**  
- Demonstrates **structs**, **arrays**, **mappings**, and **storage layout**.  
- Serves as a parent contract for `AddFiveStorage`.

---

### 5) `AddFiveStorage.sol` — **Inheritance & Override Example**  
**Description:**  
Extends `SimpleStorage` and overrides `store` to add `+5` to the stored value.  
**Concepts Demonstrated:**  
- **Inheritance** and **method overriding** (`override` keyword).  
- Illustrates Solidity’s **object-oriented** features.

---

### 6) `ParOuImpar.sol` — **Even or Odd (PvP Game)**  
**Description:**  
Two-player “Even or Odd” game: Player 1 chooses EVEN/ODD, both play a number, the contract decides the winner.  
**Key Logic:**  
- `choose("EVEN"|"ODD")` — Player 1 defines their side.  
- `play(number)` — Player 2 plays; result computed by parity of the sum.  

**Security & Best Practices:**  
- No ETH transfers — logic only.  
- Add **timeout mechanics** to avoid locked games.  
- Add **events** for match tracking or front-end integration.

---

### 7) `JoKenPo.sol` — **Rock / Paper / Scissors with Betting**  
**Description:**  
Classic on-chain Rock-Paper-Scissors game with **ETH betting** and **leaderboard tracking**.  
**Key Points:**  
- `play(choice)` — Requires `msg.value ≥ 0.01 ether`.  
- Winner gets 90% of the contract balance, owner keeps 10%.  
- Draws roll over the prize.  
- `getLeaderboard()` — Returns sorted player ranking.  

**Security Considerations:**  
- Uses `transfer` (limited gas). Safer alternative: `call{value: ...}("")`.  
- Lacks **commit-reveal**, so players can theoretically front-run each other.  
- For production: implement commit-reveal, `ReentrancyGuard`, and **event logs**.

---

### 8) `BookDatabase.sol` — **On-Chain Book Management (CRUD)**  
**Description:**  
Simple on-chain book database with add, edit, and delete operations.  
**Key Functions:**  
- `addBook(Book)` — Adds new record.  
- `editBook(id, Book)` — Updates an existing record.  
- `removeBook(id)` — Restricted to the contract owner.  

**Security & Improvements:**  
- `restricted` modifier correctly restricts deletion.  
- Bug: `editBook` only updates the title if the new title is empty (logic inverted).  
- Should emit **Created/Updated/Removed** events.  
- Use `uint` for `pages` instead of `int`.

---

## ▶️ Running on Remix

1. Open [Remix IDE](https://remix.ethereum.org/).  
2. Import contracts directly from GitHub (`File → Import from GitHub`).  
3. Compile each contract using Solidity `^0.8.x`.  
4. Deploy using **Deploy & Run Transactions**.  
5. Interact with public functions in the UI.

> 💡 Tip: For `Colchao`, run `approve(Colchao, amount)` on the ERC-20 token before calling `deposit`.

---

## 🧪 Running Locally with Foundry (optional)

```bash
forge install
anvil &
forge build
forge test -vvv
```
# Example Local Deployment (SimpleStorage):
```
forge script script/DeploySimpleStorage.s.sol:DeploySimpleStorage \
  --rpc-url http://127.0.0.1:8545 \
  --private-key <YOUR_PRIVATE_KEY> \
  --broadcast -vvvv
```

# Interact via cast:

cast send <CONTRACT_ADDRESS> "store(uint256)" 123 --rpc-url http://127.0.0.1:8545 --private-key <KEY>
cast call <CONTRACT_ADDRESS> "retrieve()(uint256)" --rpc-url http://127.0.0.1:8545

## 🛡️ Security Insights (Summary)

| **Category** | **Best Practices** |
|---------------|--------------------|
| **Access Control** | Use `Ownable` or `AccessControl` for privileged functions. |
| **Events** | Emit logs for `mint`, `burn`, `deposit`, `withdraw`, and CRUD operations. |
| **Payments** | Prefer `call{value: ...}` with a return check instead of `transfer`. |
| **Reentrancy** | Follow the *checks-effects-interactions* pattern; use `ReentrancyGuard`. |
| **Game Fairness** | Implement **commit-reveal** to prevent front-running in PvP games. |
| **ERC-20 Safety** | Use `SafeERC20` from OpenZeppelin for secure token transfers. |
| **Transparency** | Tokens backed by real assets should include off-chain proofs or audits. |

---

## 🗺️ Future Improvements

- **LuxembourgGoldToken:** integrate oracles and reserve attestations.  
- **Colchao:** add events, pausing mechanism, and `SafeERC20` implementation.  
- **JoKenPo:** implement commit-reveal, safe ETH transfers, and reentrancy protection.  
- **ParOuImpar:** add round timeouts and match history tracking.  
- **BookDatabase:** fix `editBook` logic, add events, and pagination support.  
- Add **Foundry tests** with fuzzing and coverage reports.

---

## 📜 License

All contracts include SPDX license identifiers.  
Default license: **MIT** (some educational examples under **GPL-3.0**).
