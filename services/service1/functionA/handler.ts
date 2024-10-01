import axios, { AxiosRequestConfig } from 'axios';

import { HmacSHA256, enc } from 'crypto-js';

export const config = {
  method: 'POST',
};

type Params = {
  deposit_id: number;
}

const HOST_TUPAY = 'https://api-stg.tupayonline.com';
const ENDPOINT = '/v3/deposits/';

export const main = async (event: any) => {
  const body: Params = JSON.parse(event.body);
  console.log('body', body);
  console.log(`Event: ${JSON.stringify(body)}`);

  const API_KEY = process.env.TUPAY_API_KEY;
  const API_SIGNATURE = process.env.TUPAY_API_SIG!;

  const D24_AUTHORIZATION_SCHEME = "D24 ";

  const xDate = new Date().toISOString().split('.')[0] + 'Z';

  const content = ``;

  const concatenatedString = `${xDate}${API_KEY}${content}`;

  const hash = HmacSHA256(concatenatedString, API_SIGNATURE).toString(enc.Hex);

  const signature = `${D24_AUTHORIZATION_SCHEME}${hash}`;

  const axiosConfig: AxiosRequestConfig = {
    headers: {
      'X-Date': xDate,
      'Authorization': signature,
      'X-Login': API_KEY,
    }
  };

  const response = await axios.get(`${HOST_TUPAY}${ENDPOINT}${body.deposit_id}`, axiosConfig);
  const deposit = response.data;
  console.log('deposit', deposit);

  return {
    statusCode: 200,
    body: JSON.stringify({ message: `holaa from function A.`, deposit }),
  };
};