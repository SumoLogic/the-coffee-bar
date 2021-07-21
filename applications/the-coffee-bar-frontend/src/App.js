import React from 'react';
import {
  ChakraProvider,
  Box,
  Text,
  Link,
  VStack,
  Code,
  theme,
  Image,
  Grid,
  GridItem
} from '@chakra-ui/react';
import { ColorModeSwitcher } from './ColorModeSwitcher';
import { Logo } from './Logo';

import OrderForm from './OrderForm';


function App() {
  return (
    <ChakraProvider theme={theme}>
      <Box textAlign="center" fontSize="xl">
        <Grid minH="10vh" p={3}>
          <ColorModeSwitcher justifySelf="flex-end" />
          <VStack>
            <Logo h="40vmin" pointerEvents="none" />
            <Text size='h1' fontSize='xxx-large'>Order your &#x2615; and &#x1F36A;</Text>
            <OrderForm/>
          </VStack>
        </Grid>
      </Box>
    </ChakraProvider>
  );
}

export default App;
