import React, {Component} from 'react';

class OrderForm extends Component {
  state = {
    coffee: "espresso",
    coffee_amount: 0,
    water: 0,
    grains: 0,
    sweets_amount: 0,
    sweets: [],
    bill: 0
  }

  handleCoffeeChange = event => {
    this.setState({coffee: event.target.value});
  }

  handleAmountChange = event => {
    this.setState({coffee_amount: event.target.value});
  }

  handleWaterChange = event => {
    this.setState({water: event.target.value});
  }

  handleGrainsChange = event => {
    this.setState({grains: event.target.value});
  }

  handleBillChange = event => {
    this.setState({bill: event.target.value});
  }

  handleChange = event => {
    if(event.target.checked) {
      let new_sweets = [...this.state.sweets];
      new_sweets.push(event.target.name);
      this.setState(prevState => {
        return {
          sweets_amount: prevState.sweets_amount+1,
          sweets: new_sweets
        }
      });
    } else {
      let new_sweets = [...this.state.sweets];
      let index = new_sweets.indexOf(event.target.name);
      if(index !== -1) {
        new_sweets.splice(index, 1);
      }
      this.setState(prevState => {
        return {
          sweets_amount: prevState.sweets_amount-1,
          sweets: new_sweets
        }
      });
    }
  }

  handleOrder = event => {
    event.preventDefault();
    
    fetch('http://localhost:8082/order', {
      method: 'POST',
      body: this.state,
    });
    alert('You have submitted the form.')
  }

	render() {
  	return (
    	<form onSubmit={this.handleOrder}>
      <fieldset>
        <label>
           <p>Coffee type</p>
           <select name="coffee" value={this.state.coffee} onChange={this.handleCoffeeChange} required>
               <option value="espresso">espresso</option>
               <option value="cappuccino">cappuccino</option>
               <option value="americano">americano</option>
           </select>
         </label>
         <label>
           <p>Amount</p>
           <input type="number" name="amount" step="1" onChange={this.handleAmountChange} required/>
         </label>
         <label>
           <p>Water</p>
           <input type="number" name="water" step="1" onChange={this.handleWaterChange} required/>
         </label>
         <label>
           <p>Grains</p>
           <input type="number" name="grains" step="1" onChange={this.handleGrainsChange} required/>
         </label>
         <label>
         <p>Cornetto</p>
          <input type="checkbox" name="cornetto" checked={this.state.sweets.includes("cornetto")} onChange={this.handleChange}/>
         </label>
         <label>
         <p>Cannolo siciliano</p>
          <input type="checkbox" name="cannolo_siciliano" checked={this.state.sweets.includes("cannolo_siciliano")} onChange={this.handleChange}/>
         </label>
         <label>
         <p>Torta</p>
          <input type="checkbox" name="torta" checked={this.state.sweets.includes("torta")} onChange={this.handleChange}/>
         </label>
         <label>
         <p>Muffin alla ricotta</p>
          <input type="checkbox" name="muffin_alla_ricotta" checked={this.state.sweets.includes("muffin_alla_ricotta")} onChange={this.handleChange}/>
         </label>
         <label>
         <p>Budini fiorentini</p>
          <input type="checkbox" name="budini_fiorentini" checked={this.state.sweets.includes("budini_fiorentini")} onChange={this.handleChange}/>
         </label>
         <label>
         <p>Tiramisu</p>
          <input type="checkbox" name="tiramisu" checked={this.state.sweets.includes("tiramisu")} onChange={this.handleChange}/>
         </label>
         <label>
           <p>Bill</p>
           <input type="number" name="bill" step="1" onChange={this.handleBillChange} required/>
         </label>
       </fieldset>
      <button type="order">Order</button>
      </form>
    );
  }
}

export default OrderForm;