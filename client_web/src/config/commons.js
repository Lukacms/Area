export const getByValue = (map, searchKey) => {
  for (const [key, value] of map.entries()) {
    if (key === searchKey) {
      return value;
    }
  }
};

export const listToJsonObject = (strList) => {
  const json = {};

  if (strList)
    strList.forEach((item) => (json[item] = ''));
  return JSON.stringify(json);
};
