import React, {Component} from 'react';

class OrderForm extends Component {
  state = {
    coffee: "espresso",
    coffee_amount: 0,
    water: 0,
    grains: 0,
    sweets_amount: 0,
    sweets: "cornetto",
    bill: 0
  }

  handleCoffeeChange = event => {
    this.setState({coffee: event.target.value});
  }

  handleSweetsChange = event => {
    this.setState({sweets: event.target.value});
  }

  handleCoffeeAmountChange = event => {
    this.setState({coffee_amount: event.target.valueAsNumber});
  }

   handleSweetsAmountChange = event => {
    this.setState({sweets_amount: event.target.valueAsNumber});
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
               <p>Coffee</p>
               <select name="coffee" value={this.state.coffee} onChange={this.handleCoffeeChange} required>
                   <option value="espresso">espresso</option>
                   <option value="cappuccino">cappuccino</option>
                   <option value="americano">americano</option>
               </select>
             </label>
             <label>
               <p>Coffee amount</p>
               <input type="number" name="amount" step="1" onChange={this.handleCoffeeAmountChange} required/>
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
                   <option value="cannolo_siciliano">cannolo siciliano</option>
                   <option value="cheesecake">cheesecake</option>
                   <option value="cornetto">cornetto</option>
                   <option value="torta">torta</option>
                   <option value="muffin_alla_ricotta">muffin alla ricotta</option>
                   <option value="budini_fiorentini">budini fiorentini</option>
                   <option value="tiramisu">tiramisu</option>
               </select>
             </label>
             <label>
               <p>Sweets amount</p>
               <input type="number" name="sweets_amount" step="1" onChange={this.handleSweetsAmountChange} required/>
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
