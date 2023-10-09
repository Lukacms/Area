export const getByValue = (map, searchKey) => {
  for (const [key, value] of map.entries()) {
    if (key === searchKey) {
      return value;
    }
  }
}
