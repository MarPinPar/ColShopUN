export const parseDate = (dateStr) => {
    const date = new Date(Date.parse(dateStr));
    return date.toLocaleString();
}

export const parsePrice = (priceStr) => {
    const price = parseFloat(priceStr);
    return "COP $" + price.toLocaleString();
}