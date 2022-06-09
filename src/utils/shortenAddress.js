export const shortenAddress = (address) => {
  let x = address.slice(0, 5);
  console.log(x);
  let y = address.slice(address.length - 4, address.length);

  return x + "..." + y;
};
