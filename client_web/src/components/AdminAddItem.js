import { Field, Form, Formik } from 'formik';
import FormikInputtext from './FormikInputtext';
import { Dropdown } from 'primereact/dropdown';
import { Button } from 'primereact/button';

const AdminAddItem = ({ initalValues, validate, onSubmit, services }) => {
  return (
    <Formik initialValues={initalValues} validationSchema={validate} onSubmit={onSubmit}>
      {(props) => (
        <Form
          style={{
            rowGap: '2vh',
            display: 'flex',
            flexDirection: 'column',
            marginTop: '1vh',
            width: '11.7vw',
            marginLeft: '2vw',
            marginBottom: '1.5vh',
          }}>
          <Field
            name='name'
            type='name'
            as={FormikInputtext}
            field='name'
            label='Name'
            error={props.errors?.name}
            touched={props.touched?.name}
          />
          <Field
            name='endpoint'
            type='endpoint'
            as={FormikInputtext}
            field='endpoint'
            label='Endpoint'
            error={props.errors?.endpoint}
            touched={props.touched?.endpoint}
          />
          <Field
            name='service'
            type='service'
            as={Dropdown}
            value={props.values.service}
            options={services}
            optionLabel='name'
            filter
            showClear
            onChange={(e) => props.setFieldValue('service', e.value)}
            placeholder='Select a service'
            error={props.errors?.service}
            touched={props.touched?.service}
          />
          <Button type='submit' label='Add new Action' severity='info' />
        </Form>
      )}
    </Formik>
  );
};

export default AdminAddItem;
