# DCTableViewController

### Why wrapper for table view handling?
Possible problems when working with table views:

1. Classic tableview handling is sometimes too low-level
    
2. Working with indexpaths in complex and dynamicaly changing tables is painful

3. Animated table view changes are often source of crashes
   
4. Data source of table is described in procedural rather than declarative way

DCTableViewController library tries to solve these problems:  

1. All you need to do is to describe the presented content in data source. TableView methods have default implementation that can be always customized.

2. Sections and cells are accessible using their ID instead of indextpath

3. Animated table changes are created automatically by checking the changes in data source (the previous and the current state of table)

4. Content is described using flexible expressions

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
We need to register the cells used in the table (from nib or class). This phase is not handled by DCTableViewControllerNot part of DCTableViewController. ReusableView (FromNib) from Allan & Luca. Requirement: reuse identifier is equal to class name. 

#### 2. Registration of TableViews 
We need to register tableView in controller. It will create the data structure associated with the table. If we have multiple tables, each one should have different *tag* property (used as a key)

registerTableView

```struct DCTableViewStructure<C: CellDescribing, S: SectionDescribing> {

    var dataSourceCells: [[C]] = []
    var previousDataSourceCells: [[C]] = []
    
    var dataSourceSections: [S] = []
    var previousDataSourceSections: [S] = []
}```

These arrays describes table content in current state and previous state. It is important for animated tableView changes

#### 3. Create data source for the table
SectionDescription
CellDescription
The initializer of this struct has default value for each parameter - flexible notation

#### 4. Table view cell creation
Table view cells should comply with DCTableViewCellProtocol.

```func updateCell(viewModel: Any, delegate: Any?)```

The cell knows the type of its view model and the cell makes the viewModel type casting. The cell is updated using its view model automatically.
Because sometimes not all data that are necessary for cell creation are stored in cell viewModel. We can customize cell creation using these delegate methods. 

Before cell update using cell view model
```func tableView(
        tableView: UITableView,
        willUpdateCell cell: UITableViewCell,
        cellDescription: CellDescription)```

After cell update using cell view model
```    func tableView(
        tableView: UITableView,
        didUpdateCell cell: UITableViewCell,
        cellDescription: CellDescription)```

### Batch updates
delete - update - insert

### Open problems:
* How to implement it more generically and avoid using Any as a type of viewModel? (associated types?)
* How to make it more encapsulated and separated from the project (pod)?
  