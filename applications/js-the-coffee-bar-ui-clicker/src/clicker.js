const puppeteer = require('puppeteer');

const utils = require('./utils')
require('console-stamp')(console);

const UI_URL_ARG = process.argv.slice(2);
const COFFEE_BAR_UI_URL = UI_URL_ARG[0] || process.env.COFFEE_BAR_UI_URL || 'http://the-coffee-bar-frontend:3000'; // The Coffee Bar UI URL
const DELAY = parseInt(process.env.CLICKER_INTERVAL) || 5; // Browser sleep interval in seconds
const BROWSER = process.env.PUPPETEER_PRODUCT || 'chrome'
const DEBUG_DUMPIO_ENV = process.env.DEBUG_DUMPIO || false

const GLOBAL_SELECTORS = {
    'checkoutBtn': 'button[name="Checkout"]',
    'okBtn': 'button[name="OkBtn"]',
    'payBtn': 'button[name="Pay"]',
    'billInput': 'input[name="Bill"]',
};

const COFFEE = {
    'Espresso': [0, 79],
    'Cappuccino': [80, 94],
    'Americano': [95, 100],
};
const CAKES = {
    'Cornetto': [0, 89],
    'Tiramisu': [90, 94],
    'Muffin': [95, 100],
};

const USER_AGENTS = {
    'Windows': {
        'value': '(Windows NT 10.0; Win64; x64)',
        'probScope': [0, 20],
        'browsers': {
            'Firefox': {
                'probScope': [0, 49],
                'versions': {
                    'v1': {
                        'value': 'Gecko/20100101 Firefox/96.0',
                        'probScope': [0, 49],
                    },
                    'v2': {
                        'value': 'Gecko/20100101 Firefox/89.0',
                        'probScope': [50, 100],
                    },
                },
            },
            'Chrome': {
                'probScope': [50, 100],
                'versions': {
                    'v1': {
                        'value': 'AppleWebKit/537.36 (KHTML, like Gecko) Chrome/98.0.4758.0 Safari/537.36',
                        'probScope': [0, 49],
                    },
                    'v2': {
                        'value': 'AppleWebKit/537.36 (KHTML, like Gecko) Chrome/93.0.4577.82 Safari/537.36',
                        'probScope': [50, 100],
                    },
                },
            }
        },
    },
    'Linux': {
        'value': '(X11; Linux x86_64)',
        'probScope': [21, 45],
        'browsers': {
            'Firefox': {
                'probScope': [0, 49],
                'versions': {
                    'v1': {
                        'value': 'Gecko/20100101 Firefox/96.0',
                        'probScope': [0, 49],
                    },
                    'v2': {
                        'value': 'Gecko/20100101 Firefox/89.0',
                        'probScope': [50, 100],
                    },
                },
            },
            'Chrome': {
                'probScope': [50, 100],
                'versions': {
                    'v1': {
                        'value': 'AppleWebKit/537.36 (KHTML, like Gecko) Chrome/98.0.4758.0 Safari/537.36',
                        'probScope': [0, 49],
                    },
                    'v2': {
                        'value': 'AppleWebKit/537.36 (KHTML, like Gecko) Chrome/93.0.4577.82 Safari/537.36',
                        'probScope': [50, 100],
                    },
                },
            }
        },
    },
    'Mac': {
        'value': '(Macintosh; Intel Mac OS X 12_2)',
        'probScope': [46, 60],
        'browsers': {
            'Firefox': {
                'probScope': [0, 11],
                'versions': {
                    'v1': {
                        'value': 'Gecko/20100101 Firefox/96.0',
                        'probScope': [0, 49],
                    },
                    'v2': {
                        'value': 'Gecko/20100101 Firefox/89.0',
                        'probScope': [50, 100],
                    },
                },
            },
            'Chrome': {
                'probScope': [12, 35],
                'versions': {
                    'v1': {
                        'value': 'AppleWebKit/537.36 (KHTML, like Gecko) Chrome/98.0.4758.0 Safari/537.36',
                        'probScope': [0, 49],
                    },
                    'v2': {
                        'value': 'AppleWebKit/537.36 (KHTML, like Gecko) Chrome/93.0.4577.82 Safari/537.36',
                        'probScope': [50, 100],
                    },
                },
            },
            'Safari': {
                'probScope': [36, 100],
                'versions': {
                    'v1': {
                        'value': 'AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.2 Safari/605.1.15',
                        'probScope': [0, 49],
                    },
                    'v2': {
                        'value': 'AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.1 Safari/605.1.15',
                        'probScope': [50, 100],
                    },
                },
            }
        },
    },
    'iOS': {
        'value': '(iPhone; CPU iPhone OS 15_3 like Mac OS X)',
        'probScope': [61, 80],
        'browsers': {
            'Firefox': {
                'probScope': [0, 6],
                'versions': {
                    'v1': {
                        'value': 'AppleWebKit/605.1.15 (KHTML, like Gecko) FxiOS/96.0 Mobile/15E148 Safari/605.1.15',
                        'probScope': [0, 100],
                    },
                },
            },
            'Chrome': {
                'probScope': [7, 25],
                'versions': {
                    'v1': {
                        'value': 'AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/98.0.4758.85 Mobile/15E148 Safari/604.1',
                        'probScope': [0, 100],
                    },
                },
            },
            'Safari': {
                'probScope': [26, 100],
                'versions': {
                    'v1': {
                        'value': 'AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.2 Mobile/15E148 Safari/604.1',
                        'probScope': [0, 100],
                    },
                },
            }
        },
    },
    'Android': {
        'value': '(Android 12; Mobile; rv:68.0)',
        'probScope': [81, 100],
        'browsers': {
            'Firefox': {
                'probScope': [0, 20],
                'versions': {
                    'v1': {
                        'value': 'Gecko/68.0 Firefox/96.0',
                        'probScope': [0, 100],
                    },
                },
            },
            'Chrome': {
                'probScope': [21, 100],
                'versions': {
                    'v1': {
                        'value': 'AppleWebKit/537.36 (KHTML, like Gecko) Chrome/98.0.4758.87 Mobile Safari/537.36',
                        'probScope': [0, 100],
                    },
                },
            },
        },
    },
};

const NAVIGATE_RETRY_SECONDS = 60;

(async () => {
    // console.info('Starting The Coffee Bar UI Clicker');
    // console.info(`COFFEE_BAR_UI_URL=${COFFEE_BAR_UI_URL}`);
    // console.info(`DELAY=${DELAY}`);
    // console.info(`BROWSER=${BROWSER}`);
    // console.info(`DEBUG_DUMPIO_ENV=${DEBUG_DUMPIO_ENV}`);


    while (true) {
        //console.info('Starting new browser');

        let executablePath = null;
        if (BROWSER === 'firefox') {
            executablePath = process.env.FIREFOX_BIN
        } else {
            executablePath = process.env.CHROME_BIN
        }

        let dumpio_debug = null;
        if (DEBUG_DUMPIO_ENV === 'false') {
            dumpio_debug = false;
        } else {
            dumpio_debug = true;
        }

        var browser = null;
        var page = null;
        try {
            browser = await puppeteer.launch({
                executablePath: executablePath,
                headless: true,
                dumpio: dumpio_debug,
                slowMo: 250,
                devtools: false,
                args: ['--devtools-flags=disable', '--disable-software-rasterizer', '--disable-extensions', '--wait-for-browser', '--disable-gpu', '--no-sandbox', '--disable-dev-shm-usage', '--disable-web-security'],
            });

            page = await browser.newPage();

            var userAgent = utils.chooseUserAgent(USER_AGENTS);
            var userAgentStr = `Mozilla/5.0 ${userAgent[0]} ${userAgent[1]}`;
            //console.info(`User Agent: ${userAgentStr}`);
            await page.setUserAgent(userAgentStr);

            async function clickAndSetFieldValue(selector, value, del) {
                //console.info(`Setting value: ${value} for: ${selector}`);
                await page.waitForSelector(selector, {timeout: del * 1000});
                await page.click(selector);
                await page.type(selector, String(value), {delay: utils.getRandomNumber(1000, 2000)});
            }

            async function click(selector, del) {
                //console.info(`Clicking on: ${selector}`);
                await page.waitForSelector(selector, {timeout: del * 1000});
                await page.click(selector);
            }

            // Navigate to The Coffee Bar UI
            await utils.retry(() => page.goto(COFFEE_BAR_UI_URL), NAVIGATE_RETRY_SECONDS);

            // Select Coffee to order
            let coffee = utils.choose(COFFEE);
            let coffee_selectors = {
                'input': `input[name="amount${coffee}"]`,
                'button': `button[name="add${coffee}"]`,
            }

            // Set Coffee amount
            await clickAndSetFieldValue(coffee_selectors['input'], utils.getRandomNumber(0, 5), DELAY);
            // Add Coffee
            await click(coffee_selectors['button'], DELAY);

            // Select Cakes to order
            let cakes = utils.choose(CAKES);
            let cake_selectors = {
                'input': `input[name="amount${cakes}"]`,
                'button': `button[name="add${cakes}"]`,
            }

            // Set Cakes amount
            await clickAndSetFieldValue(cake_selectors['input'], utils.getRandomNumber(0, 5), DELAY);
            // Add Cakes
            await click(cake_selectors['button'], DELAY);


            // Checkout
            await click(GLOBAL_SELECTORS['checkoutBtn'], DELAY)

            // Add bill
            await clickAndSetFieldValue(GLOBAL_SELECTORS['billInput'], utils.getRandomNumber(1, 20), DELAY);

            // Pay
            await click(GLOBAL_SELECTORS['payBtn'], DELAY);

            // Order Status ok
            if (BROWSER === 'firefox') {
                await utils.sleep(DELAY + 10);
            } else {
                await click(GLOBAL_SELECTORS['okBtn'], DELAY);
            }
        } catch (err) {
            console.error(err);
        } finally {
            await page.evaluate(() => {
                window.dispatchEvent(new Event("pagehide"));
            });
            await utils.sleep(5);
            await page.close();
            await browser.close();
        }
    }
})();
