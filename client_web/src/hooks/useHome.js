import { useRef } from 'react';
import { putArea } from '../config/request';

const useHome = () => {
  const toast = useRef();

  const changeAreaStatus = async (area, tabAreas, setTabAreas) => {
    try {
      await putArea({
        id: area.id,
        name: area.name,
        userId: area.userId,
        favorite: !area.favorite,
      });
      setTabAreas(tabAreas.map((item) => item.id === area.id ? {...item, favorite: !area.favorite} : item));
      toast.current.show({severity: 'success', summary: 'Success'});
    } catch (e) {
      toast.current.show({severity: 'error', summary: 'Could not change Area', detail: e.message});
    }
  };

  return { toast, changeAreaStatus };
};

export default useHome;
