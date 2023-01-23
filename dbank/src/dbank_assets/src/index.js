import { dbank } from "../../declarations/dbank";

window.addEventListener("load", async function() {
  update();
})

document.querySelector("form").addEventListener("submit", async function(event) {
  event.preventDefault();
  const button = event.target.querySelector("#submit-btn");
  // console.log("submitted");

  const inputAmount = parseFloat(document.getElementById("input-amount").value);
  const outputAmount = parseFloat(document.getElementById("withdrawal-amount").value);

  button.setAttribute("disabled", true);

  if(document.getElementById("input-amount").value.length != 0) {
    await dbank.add(inputAmount);
  }
  if(document.getElementById("withdrawal-amount").value.length != 0) {
    await dbank.subtract(outputAmount);
  }

  document.getElementById("input-amount").value = "";
  document.getElementById("withdrawal-amount").value = "";
  

  await dbank.compound();

  button.removeAttribute("disabled");
  update();
  
})

async function update() {
  const currentAmount = await dbank.checkBalance();
  document.getElementById("value").innerHTML = Math.round(currentAmount * 100) / 100;
}