# DCTableViewController
DCTableViewController is convenience wrapper for UITableViews in controllers. It can simplify the work with tables. 

![Image](https://dl.dropboxusercontent.com/u/57198916/DataSourceChanges.gif)

### Why wrapper for table view handling?
Possible problems when working with table views:

- Problem 1
    - **Cocoa**: Classic tableview handling is sometimes too low-level
    - **DCTableViewController**: All you need to do is to describe the presented content in data source. TableView methods have hidden default implementation that can be always customized.

- Problem 2 
    - **Cocoa**: Working with indexpaths in complex and dynamically changing tables is painful
    - **DCTableViewController**: Sections and cells are accessible using their ID instead of indextpath

- Problem 3
     - **Cocoa**: Animated table view changes are often source of crashes
     - **DCTableViewController**: Animated table changes are created automatically by checking the changes in data source (the previous and the current state of table)
  
- Problem 4
    - **Cocoa**: Data source of table is described in procedural rather than declarative way
    - **DCTableViewController**: Content is described using flexible declarative expressions

The table definition using DCTableViewController can look like this:

```swift
func createDataSourceForTable(tableView: UITableView) {
        
    super.createDataSourceForTable(tableView)
    
    let sectionDescription = SectionDescription(
        sectionID: 0,
        footerHeight: { _ in 0.01 }
    )
    
    let cellDescriptions = [
        CellDescription(
            cellID: 0,
            cellType: .MenuCell,
            viewModel: "Random Table Updates",
            didSelectCell: { [weak self] _, _, indexPath in
                self?.tableView.deselectRowAtIndexPath(indexPath, animated: true)
                self?.performSegueWithIdentifier("ShowRandomUpdates", sender: self)
            }
        ),
        CellDescription(
            cellID: 1,
            cellType: .MenuCell,
            viewModel: "Custom Table Updates",
            didSelectCell: { [weak self] _, _, indexPath in
                self?.tableView.deselectRowAtIndexPath(indexPath, animated: true)
                self?.performSegueWithIdentifier("ShowCustomUpdates", sender: self)
            }
        ),
        CellDescription(
            cellID: 2,
            cellType: .MenuCell,
            viewModel: "Infinite Loading List",
            didSelectCell: { [weak self] _, _, indexPath in
                self?.tableView.deselectRowAtIndexPath(indexPath, animated: true)
                self?.performSegueWithIdentifier("ShowInfiniteList", sender: self)
            }
        )
    ]
    
    self.tableView(tableView, addSection: sectionDescription, withCells: cellDescriptions)
}
```
### DCTableViewController

*DCTableViewController* - wrapper for UITableViewController

*DCTableSupportedViewController* - wrapper for UIViewController 
with table support

#### Features
* Both these controllers shares the implementation using protocol extensions - DCTableViewHandling
* Classic methods for table datasource and delegate are not necessary to implement
* Multiple table support in one controller
* Support for automatic animated table content changes
* Based on MVVM pattern - cells have their own ViewModel (string, number, struct, class, tuple, …)

### Life Cycle
#### 1. Cell Registration
We need to register the cells used in the table (from nib or class). This phase is not handled by DCTableViewController. You can use *registerNib:forCellWithReuseIdentifier:* and *registerClass:forCellWithReuseIdentifier:* or preferably *ReusableView* (*FromNib*) protocol from Allan & Luca. Requirement: reuse identifier is equal to class name. 
[iOS-Swiftility](https://github.com/allbto/iOS-Swiftility)

#### 2. Registration of TableViews 
We need to register tableView in controller. It will create the data structure associated with the table. If we have multiple tables, each one should have different *tag* property (used as a key)

```swift
	do {
		try registerTableView(tableView)
	}
	catch {
		print("Registration error")
	}
```

```swift
struct DCTableViewStructure<C: CellDescribing, S: SectionDescribing> {

    var dataSourceCells: [[C]] = []
    var previousDataSourceCells: [[C]] = []
    
    var dataSourceSections: [S] = []
    var previousDataSourceSections: [S] = []
}
```

These arrays describes table content in current state and previous state. It is important for animated tableView changes

#### 3. Create data source for the table
In function 
```swift
func createDataSourceForTable(tableView: UITableView)  
```

Using structs *SectionDescription* & *CellDescription*. The initializers of these structs have default value for each parameter - flexible notation.

#### 4. Table view cell creation
Table view cells should conform to *DCTableViewCellProtocol* (optional). The function updateCell is then used for updating the cell using viewModel.

```func updateCell(viewModel: Any, delegate: Any?)```

The cell knows the type of its view model and the cell makes the necessary viewModel type casting. The cell is updated using its view model automatically.
Because sometimes not all data that are necessary for cell creation are stored in cell viewModel. We can customize cell creation using these delegate methods. 

Before cell update using cell view model:

```swift
func tableView(
        tableView: UITableView,
        willUpdateCell cell: UITableViewCell,
        cellDescription: CellDescription)
```

After cell update using cell view model:

```swift
    func tableView(
        tableView: UITableView,
        didUpdateCell cell: UITableViewCell,
        cellDescription: CellDescription)
```

### Batch table updates
1. Setup the initial tableView state
2. Call *createDataSourceForTable*
3. Call *animateTableChanges* instead of *reloadData*

Batch update is sequence of insert, delete and update operations on cells and sections. Algorithm in DCTableViewController assumes that **IDs of sections and cells are in ascending order**.

### Open problems:
* How to implement it more generically and avoid using Any as a type of viewModel? (associated types?)
* How to make it more encapsulated and separated from the project (pod)?
  