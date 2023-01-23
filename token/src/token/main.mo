import Principal "mo:base/Principal";
import Text "mo:base/Text";
import Hash "mo:base/Hash";
import HashMap "mo:base/HashMap";
import Prelude "mo:base/Prelude";
import Debug "mo:base/Debug";
import Iter "mo:base/Iter";

actor Token {
    let owner : Principal = Principal.fromText("z2fwc-qnixk-rran7-yx26b-d5rtd-hkyvp-mplwz-owqu2-ndlyd-shzld-mqe");
    let totalSupply: Nat = 1000000000;
    let symbol: Text = "DANG";

    private stable var balanceEntries: [(Principal, Nat)] = [];
    // Debug.print("bbjnj");

    private var balances = HashMap.HashMap<Principal, Nat>(1, Principal.equal, Principal.hash);

    if(balances.size() < 1) {
        balances.put(owner, totalSupply);
    };

    public query func BalanceOf(who: Principal) : async Nat {
        let balance: Nat = switch (balances.get(who)) {
            case null 0;
            case (?result) result;
        };
        return balance;
    };

    public query func getSymbol(): async Text {
        return symbol;
    };

    public shared(msg) func payOut() : async Text {
        Debug.print(debug_show(msg.caller));
        if(balances.get(msg.caller) == null) {
            let amount = 10000;
            let result = await transfer(msg.caller, amount);
            // balances.put(msg.caller, amount);
            return result;
        } else {
            return "Already claimed";
        };
    };

    public shared(msg) func transfer(to: Principal, amount: Nat) : async Text {
        let fromBalance = await BalanceOf(msg.caller);
        Debug.print(debug_show(msg.caller));
        if(fromBalance >= amount) {
            let newFromBalance: Nat = fromBalance - amount;
            balances.put(msg.caller, newFromBalance);

            let toBalance = await BalanceOf(to);
            let newToBalance = toBalance + amount;
            balances.put(to, newToBalance);
            
            return "Success";

        } else {
            return "Insufficient amount";
        }
        
    };

    system func preupgrade() {
        balanceEntries := Iter.toArray(balances.entries());
    };
    
    system func postupgrade() {
        balances := HashMap.fromIter<Principal, Nat>(balanceEntries.vals(), 1, Principal.equal, Principal.hash );
        balanceEntries := [];
    };
};