import React from 'react';
import {
  ChakraProvider,
  Box,
  Center,
  Text,
  theme,
  Grid,
  Stack,
  SimpleGrid,
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
          <Center>
            <Stack isInline>
              <Box>
                <Logo h="40vmin" pointerEvents="none" />
              </Box>
              <SimpleGrid columns={1} rows={2} spacingY='10px'>
                <Box height='1px'>
                  <Text size='h1' fontSize='xxx-large' style={{ textAlign: 'left' }}>The Sumo Logic Coffee Bar</Text>
                </Box>
                <Box>
                  <Text size='h2' fontSize='xx-large' style={{ textAlign: 'left' }}>Welcome in the Sumo Logic Coffee
                    Bar.<br />You will find here best brewed coffee<br /> and the most delicious confectionery in the
                    world.<br />Take your time and order your &#x2615; and &#x1F36A;.</Text>
                </Box>
              </SimpleGrid>
            </Stack>
          </Center>
          <OrderForm />
        </Grid>
      </Box>
    </ChakraProvider>
  );
}

export default App;
