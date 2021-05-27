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

  handleSweetsChange = event => {
    this.setState({sweets: event.target.value});
  }

  handleAmountChange = event => {
    this.setState({coffee_amount: event.target.valueAsNumber});
  }

  handleWaterChange = event => {
    this.setState({water: event.target.valueAsNumber});
  }

  handleGrainsChange = event => {
    this.setState({grains: event.target.valueAsNumber});
  }

  handleBillChange = event => {
    this.setState({bill: event.target.valueAsNumber});
  }

//  handleChange = event => {
//    if(event.target.checked) {
//      let new_sweets = [...this.state.sweets];
//      new_sweets.push(event.target.name);
//      this.setState(prevState => {
//        return {
//          sweets_amount: prevState.sweets_amount+1,
//          sweets: new_sweets
//        }
//      });
//    } else {
//      let new_sweets = [...this.state.sweets];
//      let index = new_sweets.indexOf(event.target.name);
//      if(index !== -1) {
//        new_sweets.splice(index, 1);
//      }
//      this.setState(prevState => {
//        return {
//          sweets_amount: prevState.sweets_amount-1,
//          sweets: new_sweets
//        }
//      });
//    }
//  }

  handleOrder = event => {
    event.preventDefault();
    
    fetch(process.env.REACT_APP_COFFEE_BAR_URL, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify(this.state),
    })
    .then((response) => {
      return response.json()
    })
    .then((data) => {
      console.log('Success:', data);
      alert(JSON.stringify(data));
    })
    .catch((error) => {
      console.error('Error:', error);
      alert(JSON.stringify(error))
    });
  }

	render() {
  	return (
    	<form onSubmit={this.handleOrder}>
      <fieldset>
        <label>
           <p>Coffees</p>
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
           <p>Sweets</p>
           <select name="sweets" value={this.state.sweets} onChange={this.handleSweetsChange} required>
               <option value="cornetto">cornetto</option>
               <option value="cannolo_siciliano">cannolo siciliano</option>
               <option value="torta">torta</option>
               <option value="muffin_alla_ricotta">muffin alla ricotta</option>
               <option value="budini_fiorentini">budini fiorentini</option>
               <option value="tiramisu">tiramisu</option>
           </select>
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
