import Debug "mo:base/Debug";
import Int "mo:base/Int";
import Nat "mo:base/Nat";
import Time "mo:base/Time";
import Float "mo:base/Float";

actor DBank{
  stable var currentValue: Float = 300;
  // currentValue := 100;

  stable var startTime = Time.now();
  // Debug.print(debug_show(startTime));

  // let x = 116235565464;
  
  // Debug.print(debug_show(currentValue));

  // add();
  public func add(amount: Float) {
    currentValue += amount;
    Debug.print(debug_show(currentValue));
  };

  // subtract allow users to withdraw amount
  public func subtract(amount: Float) {
    let tempValue: Float = currentValue - amount;
    if(tempValue >= 0){
    currentValue -= amount;
    Debug.print(debug_show(currentValue));
    }
    else {
      Debug.print("Amount too large!!");
    }
  };

  public query func checkBalance(): async Float {
    return currentValue;
  };

  // calculating compound interest
  public func compound() {
    var currentTime = Time.now();
    var timeElapsedNS = currentTime - startTime;
    var timeElapsedS = timeElapsedNS / 1000000000;
    currentValue := currentValue * (1.01 ** Float.fromInt(timeElapsedS));
    startTime := currentTime;
  }
}