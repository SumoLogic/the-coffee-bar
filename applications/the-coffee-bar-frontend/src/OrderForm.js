import {
  AlertDialog,
  AlertDialogBody,
  AlertDialogFooter,
  AlertDialogHeader,
  AlertDialogContent,
  AlertDialogOverlay,
  AlertDialogCloseButton,
  Badge,
  Box,
  Button,
  Center,
  NumberInput,
  NumberInputField,
  Image,
  Stack,
  Text,
} from '@chakra-ui/react';
import React, { Component } from 'react';

class OrderForm extends Component {
  state = {
    coffee: '',
    coffee_amount: 0,
    coffee_price: 0,
    water: 0,
    grains: 0,
    sweets: '',
    sweets_amount: 0,
    sweets_price: 0,
    bill: 0,
    order_dialog: false,
    order_response: false,
    result: '',
    reason: '',
    trace_id: ''
  };


  boxSettings = {
    width: '400px',
    round: '30px',
    overflow: 'hidden',
    bgc: 'grey',
    bs: 'sm',
  };

  productTxtSettings = {
    h: 'h2',
    fw: 'semibold',
    fs: 'xl',
    smallTxtSize: 'md',
    style: { textAlign: 'left' },
  };

  order = {
    coffee: '',
    coffee_amount: 0,
    water: 0,
    grains: 0,
    sweets: '',
    sweets_amount: 0,
    bill: 0,
  };

  handleUpdateOrder() {
    this.order.coffee = this.state.coffee;
    this.order.coffee_amount = this.state.coffee_amount;
    this.order.water = this.state.water;
    this.order.grains = this.state.grains;
    this.order.sweets = this.state.sweets;
    this.order.sweets_amount = this.state.sweets_amount;
    this.order.bill = this.state.bill;
  }

  handleOrder = event => {
    event.preventDefault();
    this.handleUpdateOrder();
    this.setState({ order_dialog: false });
    fetch(process.env.REACT_APP_COFFEE_BAR_URL, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'pragma': 'no-cache',
        'cache-control': 'no-cache',
      },
      body: JSON.stringify(this.order),
    })
      .then((response) => {
        return response.json();
      })
      .then((res) => {
        this.setState({ order_response: true });
        if ('reason' in res) {
          this.setState({ reason: res['reason'] });
        }
        if ('result' in res) {
          this.setState({ result: res['result'] });
        }

        if ('trace_id' in res) {
          this.setState({ trace_id: res['trace_id'] });
        }
      })
      .catch((error) => {
        console.error('Error:', error.toString());
        this.setState({ reason: error.toString() });
        this.setState({ order_response: true });
      });
  };

  handleBillChange = val => {
    if (val instanceof String) {
      this.setState({ bill: +val });
    } else if (Number.isInteger(val)) {
      this.setState({ bill: val });
    } else if (val instanceof Object) {
      this.setState({ bill: +val.target.value });
    }
  };

  changeCoffeeAmount = val => {
    if (val instanceof String) {
      this.setState({ coffee_amount: +val });
    } else if (Number.isInteger(val)) {
      this.setState({ coffee_amount: val });
    } else if (val instanceof Object) {
      this.setState({ coffee_amount: +val.target.value });
    }
  };

  changeSweetsAmount = val => {
    if (val instanceof String) {
      this.setState({ sweets_amount: +val });
    } else if (Number.isInteger(val)) {
      this.setState({ sweets_amount: val });
    } else if (val instanceof Object) {
      this.setState({ sweets_amount: +val.target.value });
    }
  };

  handleAddEspresso = () => {
    this.setState({
      water: 60,
      grains: 40,
      coffee: 'espresso',
      coffee_price: 2,
    });
  };

  handleAddCappuccino = () => {
    this.setState({
      water: 60,
      grains: 0,
      coffee: 'cappuccino',
      coffee_price: 4,
    });
  };

  handleAddAmericano = () => {
    this.setState({
      water: 0,
      grains: 80,
      coffee: 'americano',
      coffee_price: 3,
    });
  };

  handleAddTiramisu = () => {
    this.setState({
      sweets: 'tiramisu',
      sweets_price: 3,
    });
  };

  handleAddCornetto = () => {
    this.setState({
      sweets: 'cornetto',
      sweets_price: 1,
    });
  };

  handleAddMuffin = () => {
    this.setState({
      sweets: 'muffin',
      sweets_price: 1,
    });
  };

  createProduct = (img, name, product, product_desc, price, handleChange, handleAdd) => {
    let servings = name + ' servings number';
    return (
      <Box w={this.boxSettings.width} rounded={this.boxSettings.round} overflow={this.boxSettings.overflow}
           backgroundColor={this.boxSettings.bgc} boxShadow={this.boxSettings.bs}>
        <Center>
          <Image boxSize='sm' borderRadius='full' src={img} alt={name} />
        </Center>
        <Text as={this.productTxtSettings.h} fontWeight={this.productTxtSettings.fw}
              fontSize={this.productTxtSettings.fs}>{product}</Text>
        <Text fontSize={this.productTxtSettings.smallTxtSize} style={this.productTxtSettings.style}
              textOverflow='ellipsis' display='-webkit-flex' _webkit_line_clamp={2}
              _webkit-box-orient='vertical'>{product_desc}</Text>
        <Badge>Price: ${price}</Badge>
        <Center>
          <NumberInput name={name} id={name} placeholder={servings} inputMode='numeric' min={0} max={30} allowMouseWheel
                       focusBorderColor='lime' w='350px'>
            <NumberInputField value={this.state.coffee_amount} placeholder={servings} textTransform='uppercase'
                              onChange={handleChange} onWheel={handleChange} />
          </NumberInput>
        </Center>
        <Center>
          <Button name={name} id={name} size='lg' mt={3} boxShadow='sm' _hover={{ boxShadow: 'md ' }}
                  _active={{ boxShadow: 'lg' }} textTransform='uppercase' onClick={handleAdd}>
            Add
          </Button>
        </Center>
      </Box>
    );
  };

  render() {
    return (
      <Center>
        <Box>

          <Text fontSize='xx-large' textTransform='uppercase' fontWeight='semibold'>Coffee menu:</Text>

          <Stack isInline align='baseline' justifyContent='space-between'>
            {this.createProduct(
              './andres-vera-unsplash-espresso.jpg',
              'Espresso',
              'Espresso, where it all begins!',
              'The espresso, also known as a short black, is approximately 1 oz. of highly concentrated coffee.',
              '2',
              this.changeCoffeeAmount,
              this.handleAddEspresso,
            )
            }
            {this.createProduct(
              './cappuccino.jpg',
              'Cappuccino',
              'Cappucino, to feel the clouds!',
              'A cappuccino is a coffee-based drink made primarily from espresso and milk.',
              '4',
              this.changeCoffeeAmount,
              this.handleAddCappuccino,
            )
            }
            {this.createProduct(
              './christina-dibernardo-americano-unsplash.jpg',
              'Americano',
              'Americano, to have more!',
              'An Americano is an espresso-based drink designed to resemble coffee brewed in a drip filter.',
              '3',
              this.changeCoffeeAmount,
              this.handleAddAmericano,
            )
            }
          </Stack>
          <Text fontSize='xx-large' textTransform='uppercase' fontWeight='semibold'>Pastry menu:</Text>
          <Stack isInline align='baseline' spacing='10px'>
            {this.createProduct(
              './vika-aleksandrova-tiramisu-unsplash.jpg',
              'Tiramisu',
              'Tiramisu, elegant and rich layered!',
              'Tiramisu, the delicate flavor of layers of mascarpone and Italian custard are contrasted with the darklyrobust presence of espresso and sharpness of cocoa powder.',
              '3',
              this.changeSweetsAmount,
              this.handleAddTiramisu,
            )
            }
            {this.createProduct(
              './olia-gozha-cornetto-unsplash.jpg',
              'Cornetto',
              'Cornetto, delicious and crispy-baked wafer!',
              'Cornetto is an Italian variation of the Austrian kipferl. A cornetto with an espresso or cappuccino at a coffee bar is considered to be the most common breakfast in Italy.',
              '1',
              this.changeSweetsAmount,
              this.handleAddCornetto,
            )
            }
            {this.createProduct(
              './jennifer-pallian-muffin-unsplash.jpg',
              'Muffin',
              'Muffin, just a bit of sweetness!',
              'A muffin is batter-based bakery product. It’s formulation is somewhere in between a low-ratio cake and quick bread. Muffin batter is typically deposited or placed into deep, small cup-shaped pan before baking.',
              '1',
              this.changeSweetsAmount,
              this.handleAddMuffin,
            )
            }
          </Stack>
          <Box>
            <Button name='Checkout' id='Checkout' colorScheme="blue" size='lg' fontSize='x-large'
                    textTransform='uppercase' onClick={() => {
              this.setState({ order_dialog: true });
            }}>
              Checkout
            </Button>
            <AlertDialog
              motionPreset="slideInBottom"
              isOpen={this.state.order_dialog}
              onClose={() => {
                this.setState({ order_dialog: false });
              }}
              isCentered
            >
              <AlertDialogOverlay />
              <AlertDialogContent>
                <AlertDialogHeader>Accept order?</AlertDialogHeader>
                <AlertDialogCloseButton />
                <AlertDialogBody>
                  Coffee: {this.state.coffee} x{this.state.coffee_amount} {this.state.coffee_amount * this.state.coffee_price}$<br />
                  Pastry: {this.state.sweets} x{this.state.sweets_amount} {this.state.sweets_amount * this.state.sweets_price}$<br />
                  Total: {this.state.coffee_amount * this.state.coffee_price + this.state.sweets_amount * this.state.sweets_price}$
                </AlertDialogBody>
                <AlertDialogFooter>
                  <NumberInput name='Bill' id='Bill' placeholder='Please provide bill \$' inputMode='numeric' min={0}
                               max={500} allowMouseWheel focusBorderColor='lime'>
                    <NumberInputField value={this.state.bill} placeholder='Please provide bill \$'
                                      textTransform='uppercase' onChange={this.handleBillChange}
                                      onWheel={this.handleBillChange} />
                  </NumberInput>
                  <Button name='No' id='No' colorScheme='red' ml={3} onClick={() => {
                    this.setState({ order_dialog: false });
                  }}>
                    No
                  </Button>
                  <Button name='Pay' id='Pay' colorScheme='green' ml={3} onClick={this.handleOrder}>
                    Pay
                  </Button>

                </AlertDialogFooter>
              </AlertDialogContent>
            </AlertDialog>

            <AlertDialog
              motionPreset='scale'
              isOpen={this.state.order_response}
              onClose={() => {
                this.setState({ order_response: false });
              }}
              isCentered
            >
              <AlertDialogOverlay />
              <AlertDialogContent>
                <AlertDialogHeader>Order Status</AlertDialogHeader>
                <AlertDialogCloseButton />
                <AlertDialogBody>
                  Result: {this.state.result}<br />
                  Reason: {this.state.reason}<br />
                  TraceID: {this.state.trace_id}
                </AlertDialogBody>
                <AlertDialogFooter>
                  <Button name='OkBtn' id='OkBtn' colorScheme='green' ml={3} onClick={() => {
                    this.setState({ order_response: false });
                  }}>
                    OK
                  </Button>
                </AlertDialogFooter>
              </AlertDialogContent>
            </AlertDialog>
          </Box>

        </Box>
      </Center>
    );
  }
}

export default OrderForm;
