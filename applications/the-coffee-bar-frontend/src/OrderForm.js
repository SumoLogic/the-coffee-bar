import { Badge, Box, Icon, Image, Stack, Text, Popover,
  NumberInput,
  NumberInputField,
  NumberInputStepper,
  NumberIncrementStepper,
  NumberDecrementStepper,
  Button,
  useColorMode,
  FormControl,
  Center,
  Formik,
  Form,
  Field,
  Input,
  space,} from '@chakra-ui/react';
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

  handleEspressoIncrementation = value => {
    this.setState({coffee_amount: +value});
    this.setState({water: 60});
    this.setState({grains: 40});
    this.setState({coffee: 'espresso'});
  }

  handleEspresso = event => {
    console.error(event.target.value)
    this.setState({coffee_amount: +event.target.value});
    this.setState({water: 60});
    this.setState({grains: 40});
    this.setState({coffee: 'espresso'});
  }

  handleEspressoA = event => {
    console.error(event)
    this.setState({coffee_amount: +event.target.value});
    this.setState({water: 60});
    this.setState({grains: 40});
    this.setState({coffee: 'espresso'});
  }

  handleCappuccinoIncrementation = value => {
    this.setState({coffee_amount: +value});
    this.setState({water: 60});
    this.setState({grains: 0});
    this.setState({coffee: 'cappuccino'});
  }

  handleCappuccino = event => {
    this.setState({coffee_amount: +event.target.value});
    this.setState({water: 60});
    this.setState({grains: 0});
    this.setState({coffee: 'cappuccino'});
  }

  handleAmericanoIncrementation = value => {
    this.setState({coffee_amount: +value});
    this.setState({water: 0});
    this.setState({grains: 40});
    this.setState({coffee: 'americano'});
  }

  handleAmericano = event => {
    this.setState({coffee_amount: +event.target.value});
    this.setState({water: 0});
    this.setState({grains: 40});
    this.setState({coffee: 'americano'});
  }


   handleSweetsAmountChange = event => {
    this.setState({sweets_amount: event.target.valueAsNumber});
  }

  handleWaterChange = event => {
    this.setState({grains: event.target.valueAsNumber});
  }

  handleGrainsChange = event => {
    this.setState({grains: event.target.valueAsNumber});
  }

  handleBillChange = event => {
    this.setState({bill: event.target.valueAsNumber});
  }

  handleOrder = event => {
    event.preventDefault();
    console.error(this.state);
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
      <Center>
        <Stack isInline align='baseline'>
        
            <Box w='400px' rounded='30px' overflow='hidden' backgroundColor='grey' boxShadow='sm'>
              <Image boxSize='sm' borderRadius='full' src='./andres-vera-unsplash-espresso.jpg' alt='Espresso' />
              <Text as='h2' fontWeight='semibold' fontSize='xl'>Espresso, where it all begins</Text>
              <Text fontSize='md'>The espresso, also known as a short black, is approximately 1 oz. of highly concentrated coffee.</Text>
              <Badge>Price: $2</Badge>
              <FormControl>
            
              <Center>
              <NumberInput id='espresso_input' name='espresso_input' inputMode='numeric' min={0} max={30} allowMouseWheel focusBorderColor='lime' onWheel={this.handleEspresso} onChange={this.handleEspressoIncrementation} w='350px'>
              <NumberInputField placeholder='Number of Espresso cups' onChange={this.handleEspresso}/>
                    <NumberInputStepper >
                      <NumberIncrementStepper />
                      <NumberDecrementStepper/>
                    </NumberInputStepper>
                  </NumberInput>
                </Center>
                </FormControl>
                <Center>
                  <Button
                    variantColor='teal'
                    size='lg'
                    mt={3}
                    boxShadow='sm'
                    _hover={{ boxShadow: 'md '}}
                    _active={{ boxShadow: 'lg' }}
                    onClick={this.handleEspressoA}>
                    Add Espresso
                  </Button>
                </Center>
            </Box>
            

            <Box w='400px' rounded='20px' overflow='hidden' backgroundColor='gray' boxShadow='sm'>
            <Image boxSize='sm' borderRadius='full' src='./cappuccino.jpg' alt='Cappuccino' />
            <Text as='h2' fontWeight='semibold' fontSize='xl'>Cappucino, to feel the clouds</Text>
            <Text fontSize='md'>The espresso, also known as a short black, is approximately 1 oz. of highly concentrated coffee.</Text>
            <Badge>Price: $4</Badge>
              <Center>
              <NumberInput inputMode='numeric' min={0} max={30} allowMouseWheel focusBorderColor='lime' onWheel={this.handleCappuccino} onChange={this.handleCappuccinoIncrementation} w='350px'>
                <NumberInputField placeholder='Number of Cappuccino cups' onChange={this.handleCappuccino}/>
                  <NumberInputStepper >
                      <NumberIncrementStepper />
                      <NumberDecrementStepper/>
                    </NumberInputStepper>
                  </NumberInput>
                  </Center>

          </Box>
          <Box w='400px' rounded='20px' overflow='hidden' backgroundColor='grey' boxShadow='sm'>
            <Image boxSize='sm' borderRadius='full' src='./christina-dibernardo-unsplash-americano.jpg' alt='Americano' />
            <Text as='h2' fontWeight='semibold' fontSize='xl'>Americano, to have more!</Text>
            <Text fontSize='md'>The espresso, also known as a short black, is approximately 1 oz. of highly concentrated coffee.</Text>
            <Badge>Price: $3</Badge>
            <NumberInput inputMode='numeric' min={0} max={30} allowMouseWheel focusBorderColor='lime' onWheel={this.handleAmericano} onChange={this.handleAmericanoIncrementation} w='350px'>
              <NumberInputField placeholder='Number of Americano cups' onChange={this.handleAmericano}/>
                 <NumberInputStepper >
                    <NumberIncrementStepper />
                    <NumberDecrementStepper/>
                  </NumberInputStepper>
                </NumberInput>
          </Box>

        </Stack>
        <Button colorScheme="teal" size="xs" onClick={this.handleOrder}>
            Button
        </Button>
        </Center>
   );
  }
  

}


export default OrderForm;
