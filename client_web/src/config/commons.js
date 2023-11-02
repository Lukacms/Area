/**
 * Get the value of an element of a list<string, string> with its key
 * @param {list<string, string>} map
 * @param {string} searchKey
 * @returns {string | null}
 */
export const getByValue = (map, searchKey) => {
  for (const [key, value] of map.entries()) {
    if (key === searchKey) {
      return value;
    }
  }
  return null;
};

/**
 * transform a list of string to stringified json object
 * @example ["one", "two"] => {"one": "", "two": ""}
 * @param {list<str>} strList
 * @returns {string} stringified json object
 */
export const listToJsonObject = (strList) => {
  const json = {};

  if (strList) strList.forEach((item) => (json[item] = ''));
  return JSON.stringify(json);
};
