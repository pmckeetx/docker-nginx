import 'bootstrap/dist/css/bootstrap.css'
import React, { useState } from 'react'
import services from './services'

function App() {
  const [values, setValues] = useState({ entity: '', data: [], newEntity: '' })
  const [isCeateModalVisible, setCreateModalVisible] = useState( false )
  const [isLoading, setLoading] = useState( false )
  const [isSaving, setSaving] = useState( false )

  function handleInputChange( e ) {
    let {name, value} = e.target
    if( e.target.type === 'checkbox' ) {
      value = e.target.checked
    }
    
    setValues({...values, [name]: value})
  }

  async function handleSubmit( e ) {
    e.preventDefault()

    if( !values.entity ) {
      alert( 'Please enter an Entity name' )
      return 
    }

    setLoading(true)
    const entities = await services.searchEntities( values.entity )
    setLoading(false)

    setValues({...values, data: entities.payload})
  } 

  function getDataRows() {
    
    if( values.data && values.data.length ) {
      let colNames = Object.getOwnPropertyNames( values.data[0] )

      let rows = values.data.map( (item, rowIndex) => {
        let row = (
          <tr key={`row-${rowIndex}`}>
            { colNames.map( (n, colIndex) => <td key={`row-${rowIndex}--col-${colIndex}`}>{item[n]}</td> )}
          </tr>
        )
        return row
      })

      return rows
    }
  }

  function handleCreateNewClick() {
    setCreateModalVisible( true )
  }

  async function handleCreateNewSaveClick() {
    if( !values.entity ) {
      alert( 'Please enter an Entity name' )
      return 
    }

    setSaving(true)
    await services.createEntity( values.entity, JSON.parse( values.newEntity ) )
    setSaving(false)

    setLoading(true)
    const entities = await services.searchEntities( values.entity )
    setLoading(false)
    setValues({...values, data: entities.payload})

  }

  function handleCreateNewCancelClick() {
    setCreateModalVisible( false )
  }
  
  return (
    <div className="App">
      <div className="container">
        <h2>Ronin App Template</h2>
        <form>
          <div className="form-group">
            <label htmlFor="exampleInputEmail1">Enter an entity:</label>
            <input type="textbox" className="form-control" onChange={ handleInputChange } value={ values.entity } name="entity"/>
          </div>
          <button type="submit" onClick={ e => handleSubmit(e) } className="btn btn-primary">Submit</button>
          <span style={{ "display": "inline-block", "marginLeft": "5px", "marginRight": "5px"}}></span>
          <button type="button" onClick={ handleCreateNewClick } className="btn btn-secondary">Create New Record</button>
        </form>

        { isCeateModalVisible
          ? (
            <div style={{marginTop: "25px"}} className="alert alert-success" role="alert">
              <h4 className="alert-heading">Create New Record</h4>
              <form>
                <div className="form-group">
                  <label htmlFor="exampleFormControlTextarea1">Enter JSON below:</label>
                  <textarea className="form-control" rows="8" onChange={ handleInputChange } value={ values.newEntity } name="newEntity"></textarea>
                </div>
                <div style={{width: "100%", "paddingBottom": "40px"}}>
                  <div className="float-left">
                    { isSaving ? <span>Saving...</span> : ''}
                  </div>
                  <div className="float-right">
                    <button type="button" onClick={ handleCreateNewSaveClick } className="btn btn-primary">Save</button>
                    <span style={{ "display": "inline-block", "marginLeft": "5px", "marginRight": "5px"}}></span>
                    <button type="button" onClick={ handleCreateNewCancelClick } className="btn btn-secondary">Cancel</button>
                  </div>
                </div>
              </form>
            </div>
          ) : (
            ''
          )
        }

        <div style={{marginTop: "75px"}}>
          <h3>Results: {values.entity}</h3>
          <div>
            { values.data.length
              ? (
                <table className="table table-striped">
                  <thead>
                    <tr>
                      { Object.getOwnPropertyNames( values.data[0] ).map( (name, index) => <th key={`${index}-${name}`} scope="col">{name}</th>) }
                    </tr>
                  </thead>
                  <tbody>
                    { getDataRows() }
                  </tbody>
                </table>
              ) : ( 
                isLoading
                  ? <span>Loading...</span>
                  : <span>No results</span>
              )
            }
          </div>
        </div>
      </div>
    </div>
  )
}

export default App
