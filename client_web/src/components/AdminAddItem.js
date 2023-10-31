import { Button } from 'primereact/button';
import { Field, Form, Formik } from 'formik';
import { FormikChip, FormikDropdown, FormikInputArea, FormikInputtext } from '.';

const AdminAddItem = ({ initalValues, validate, onSubmit, services }) => {
  return (
    <Formik
      initialValues={initalValues}
      validationSchema={validate}
      onSubmit={(values, { resetForm }) => {
        onSubmit(values);
        resetForm();
      }}>
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
            as={FormikDropdown}
            value={props.values.service}
            options={services}
            optionLabel='name'
            filter
            showClear
            label='Services'
            onChange={(e) => props.setFieldValue('service', e.value)}
            placeholder='Select a service'
            error={props.errors?.service}
            touched={props.touched?.service}
          />
          <Field
            name='defaultConfig'
            type='defaultConfig'
            as={FormikChip}
            label='Configuration'
            value={props.values.defaultConfig}
            error={props.errors?.defaultConfig}
            touched={props.touched?.defaultConfig}
            tooltip='Configuration entries. Separate them with <Enter> key.'
          />
          <Field
            name='description'
            type='description'
            as={FormikInputArea}
            field='description'
            label='Description'
            error={props.errors?.description}
            touched={props.touched?.description}
            tooltip='How the action or reaction works.'
          />
          <Button type='submit' label='Add new Item' severity='info' />
        </Form>
      )}
    </Formik>
  );
};

export default AdminAddItem;
