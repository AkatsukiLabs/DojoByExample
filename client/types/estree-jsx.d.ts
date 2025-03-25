declare module 'estree-jsx' {
    import * as ESTree from 'estree';
    
    export interface JSXAttribute {
      type: 'JSXAttribute';
      name: JSXIdentifier;
      value: JSXAttributeValue | null;
    }
    
    export interface JSXIdentifier {
      type: 'JSXIdentifier';
      name: string;
    }
    
    export type JSXAttributeValue = 
      | JSXExpressionContainer
      | JSXElement
      | string;
    
    export interface JSXExpressionContainer {
      type: 'JSXExpressionContainer';
      expression: ESTree.Expression;
    }
    
    export interface JSXElement {
      type: 'JSXElement';
      openingElement: JSXOpeningElement;
      children: JSXChild[];
      closingElement: JSXClosingElement | null;
    }
    
    export interface JSXOpeningElement {
      type: 'JSXOpeningElement';
      name: JSXIdentifier;
      attributes: JSXAttribute[];
      selfClosing: boolean;
    }
    
    export interface JSXClosingElement {
      type: 'JSXClosingElement';
      name: JSXIdentifier;
    }
    
    export type JSXChild = 
      | JSXElement
      | JSXExpressionContainer
      | JSXText;
    
    export interface JSXText {
      type: 'JSXText';
      value: string;
    }
  }
  