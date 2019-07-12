import {Pagination, PaginationItem, PaginationLink} from "reactstrap";
import {observer, inject} from "mobx-react";
import React from "react";
@inject("userStore")
@observer
export default class UsersTablePagination extends React.Component {
  handlePaginationClick(e, pageNumber) {
    e.preventDefault();
    if ( pageNumber < 1 ||
        pageNumber > this.props.userStore.totalPages ||
        pageNumber == this.props.userStore.currentPage )
      return;
    this.props.userStore.setCurrentPage(pageNumber);
  }
   render() {
     return(
       <Pagination aria-label="Page navigation example">
       <PaginationItem>
         <PaginationLink first href="#" onClick={e => this.handlePaginationClick(e, 1) }/>
       </PaginationItem>
       <PaginationItem disabled={ this.props.userStore.currentPage == 1} >
         <PaginationLink
           previous href="#"
           onClick={e =>
            this.handlePaginationClick(e,  this.props.userStore.currentPage - 1)
           }
         />
       </PaginationItem>
       {[...Array(this.props.userStore.totalPages)].map (
         (page, i) => {
           return(
             <PaginationItem active={ i+1 == this.props.userStore.currentPage }>
             <PaginationLink href="#" onClick={e => this.handlePaginationClick(e, i + 1)}>
               {i + 1}
             </PaginationLink>
           </PaginationItem>
           )
         }
       )}
       <PaginationItem disabled={ this.props.userStore.currentPage == this.props.userStore.totalPages }>
         <PaginationLink
           next href="#"
           onClick={e =>
             this.handlePaginationClick(e,  this.props.userStore.currentPage + 1)
           }
         />
       </PaginationItem>
       <PaginationItem>
         <PaginationLink last href="#" onClick={e => this.handlePaginationClick(e, this.props.userStore.totalPages) }/>
       </PaginationItem>
     </Pagination>
     )
   }
 }
