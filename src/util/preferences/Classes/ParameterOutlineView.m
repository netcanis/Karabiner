#import "ParameterOutlineView.h"
#import "ParameterTree.h"

@interface ParameterOutlineView ()

@property(weak) NSTableCellView* mouseDownCellView;

@end

@implementation ParameterOutlineView

- (BOOL)validateProposedFirstResponder:(NSResponder*)responder forEvent:(NSEvent*)event {
  NSPoint point = [self convertPoint:event.locationInWindow fromView:nil];
  NSInteger column = [self columnAtPoint:point];
  if (column == 2) {
    return YES;
  } else {
    return NO;
  }
}

- (BOOL)acceptsFirstMouse:(NSEvent*)theEvent {
  return NO;
}

- (void)mouseDown:(NSEvent*)theEvent {
  NSPoint point = [self convertPoint:theEvent.locationInWindow fromView:nil];
  NSInteger row = [self rowAtPoint:point];
  NSInteger column = [self columnAtPoint:point];
  if (column == 0 && row >= 0) {
    self.mouseDownCellView = [self viewAtColumn:column row:row makeIfNecessary:NO];
  } else {
    self.mouseDownCellView = nil;
  }
}

- (void)mouseUp:(NSEvent*)theEvent {
  NSPoint point = [self convertPoint:theEvent.locationInWindow fromView:nil];
  NSInteger row = [self rowAtPoint:point];
  NSInteger column = [self columnAtPoint:point];
  if (column == 0 && row >= 0) {
    NSTableCellView* view = [self viewAtColumn:column row:row makeIfNecessary:NO];
    if (self.mouseDownCellView == view) {
      // clicked
      ParameterTree* item = [self itemAtRow:row];
      if ([self isExpandable:item]) {
        if ([self isItemExpanded:item]) {
          if ([self selectedRow] == row) {
            [self collapseItem:item];
          } else {
            [self selectRowIndexes:[NSIndexSet indexSetWithIndex:(NSUInteger)(row)] byExtendingSelection:NO];
          }
        } else {
          [self selectRowIndexes:[NSIndexSet indexSetWithIndex:(NSUInteger)(row)] byExtendingSelection:NO];
          [self expandItem:item];
        }
        [[self window] makeFirstResponder:self];
      }
    }
  }
  self.mouseDownCellView = nil;
}

@end
