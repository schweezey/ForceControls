//
//  LabelTextField.swift
//  
//
//  Created by Josh McBroom on 1/16/24.
//

import SwiftUI

//MARK: - Style Protocol
public protocol LabelTextFieldStyle {
    func body(content: LabelTextField) -> LabelTextField
}

public struct LabelTextField: View {
    //MARK: - Binding Properties
    @Binding private var textValue: String
    @State var isSelected:Bool = false
    
    @State var isShowError: Bool = false
    @FocusState fileprivate var isFocused: Bool
    @State private var textFieldHeight: CGFloat = 0.0
    
    //MARK: - model Observed Object
    @ObservedObject private var model = LabelTextFieldModel()
    
    //MARK: - Properties
    private var placeholderText: String = ""
    private var editingChanged: (Bool) -> () = { _ in }
    private var commit: () -> () = { }
    
    //MARK: - Init
    public init(_ text: Binding<String>, placeholder: String = "", editingChanged: @escaping (Bool)->() = { _ in }, commit: @escaping ()->() = { }) {
        self._textValue = text
        self.placeholderText = placeholder
        self.editingChanged = editingChanged
        self.commit = commit
    }
    
    //MARK: - Placeholder Label View
    var placeholderLabel: some View {
        Text(model.isShowError ? model.requiredFieldMessage : placeholderText)
            .frame(alignment: model.textAlignment.getAlignment())
            .animation(.default, value: textValue.isEmpty)
            .foregroundStyle(model.isShowError ? model.errorColor : (isSelected ? model.selectedTitleColor : model.titleColor))
            .font(model.titleFont)
            .padding(.bottom, textValue.isEmpty ? 8 : CGFloat(model.spaceBetweenTitleText))
            .padding(.top, textValue.isEmpty ? CGFloat(model.spaceBetweenTitleText) : 8)
            .padding(.leading, model.leftView != nil ? (textValue.isEmpty ? 40 : 0) : 0)
    }
    
    //MARK: - Center Text View
    var centerTextField: some View {
        ZStack {
            if model.isSecureTextEntry {
                SecureField("", text: $textValue.animation())
                    .onTapGesture {
                        self.editingChanged(self.isSelected)
                        if !self.isSelected {
                            UIResponder.currentFirstResponder?.resignFirstResponder()
                        }
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                            if let currentResponder = UIResponder.currentFirstResponder, let currentTextField = currentResponder.globalView as? UITextField {
                                self.isSelected = self.model.isSecureTextEntry
                                currentTextField.addAction(UIAction(title: "EditingEnd") { (action) in
                                    self.isSelected = false
                                    self.commit()
                                }, for: .editingDidEnd)
                            }
                        }
                    }
                .padding(.bottom, 3)
            } else {
                TextField("", text: $textValue, onEditingChanged: { isChanged in
                    withAnimation {
                        DispatchQueue.main.async {
                            isSelected = isChanged
                        }
                    }
                }, onCommit: {
                    if model.isRequiredField {
                        model.isShowError = textValue.isEmpty
                    }
                })
                .padding(.bottom, 3)
            }
        }
    }
    
    //MARK: - Bottom Line View
    var bottomLine: some View {
        Divider()
            .frame(height: self.isSelected ? model.selectedLineHeight : model.lineHeight, alignment: .leading)
    }
    
    //MARK: - Body View
    public var body: some View {
        VStack {
            ZStack(alignment: .bottomLeading) {
                placeholderLabel
                
                HStack {
                    model.leftView
                        .frame(width: 30, height: 30)
                    centerTextField
                    model.rightView
                }
                
                bottomLine
                    .background(model.isShowError ? model.errorColor : (isSelected ? model.selectedLineColor : model.lineColor))
            }
        }
    }
}

//MARK: LabelTextField Style Funcation
@available(iOS 15.0, *)
extension LabelTextField {
    public func floatingStyle<S>(_ style: S) -> some View where S: LabelTextFieldStyle {
        return style.body(content: self)
    }
}

//MARK: View Property Funcation
@available(iOS 15.0, *)
extension LabelTextField {
    public func leftView<LRView: View>(@ViewBuilder _ view: @escaping () -> LRView) -> Self {
        model.leftView = AnyView(view())
        return self
    }
    
    public func rightView<LRView: View>(@ViewBuilder _ view: @escaping () -> LRView) -> Self {
        model.rightView = AnyView(view())
        return self
    }
}

//MARK: Text Property Funcation
@available(iOS 15.0, *)
extension LabelTextField {
    public func textAlignment(_ alignment: TextAlignment) -> Self {
        model.textAlignment = alignment
        return self
    }
    
    public func isSecureTextEntry(_ isSecure: Bool) -> Self {
        model.isSecureTextEntry = isSecure
        return self
    }
    
    public func disabled(_ isDisabled: Bool) -> Self {
        model.disabled = isDisabled
        return self
    }
}

//MARK: Line Property Funcation
@available(iOS 15.0, *)
extension LabelTextField {
    public func lineHeight(_ height: CGFloat) -> Self {
        model.lineHeight = height
        return self
    }
    
    public func selectedLineHeight(_ height: CGFloat) -> Self {
        model.selectedLineHeight = height
        return self
    }
    
    public func lineColor(_ color: Color) -> Self {
        model.lineColor = color
        return self
    }
    
    public func selectedLineColor(_ color: Color) -> Self {
        model.selectedLineColor = color
        return self
    }
}

//MARK: Title Property Funcation
@available(iOS 15.0, *)
extension LabelTextField {
    public func titleColor(_ color: Color) -> Self {
        model.titleColor = color
        return self
    }
    
    public func selectedTitleColor(_ color: Color) -> Self {
        model.selectedTitleColor = color
        return self
    }
    
    public func titleFont(_ font: Font) -> Self {
        model.titleFont = font
        return self
    }
    
    public func spaceBetweenTitleText(_ space: Double) -> Self {
        model.spaceBetweenTitleText = space
        return self
    }
}

//MARK: Text Property Funcation
@available(iOS 15.0, *)
extension LabelTextField {
    public func textColor(_ color: Color) -> Self {
        model.textColor = color
        return self
    }
    
    public func selectedTextColor(_ color: Color) -> Self {
        model.selectedTextColor = color
        return self
    }
    
    public func textFont(_ font: Font) -> Self {
        model.font = font
        return self
    }
}

//MARK: Placeholder Property Funcation
@available(iOS 15.0, *)
extension LabelTextField {
    public func placeholderColor(_ color: Color) -> Self {
        model.placeholderColor = color
        return self
    }
    
    public func placeholderFont(_ font: Font) -> Self {
        model.placeholderFont = font
        return self
    }
}

//MARK: Error Property Funcation
@available(iOS 15.0, *)
extension LabelTextField {
    public func isShowError(_ show: Bool) -> Self {
        model.isShowError = show
        return self
    }
    
    public func errorColor(_ color: Color) -> Self {
        model.errorColor = color
        return self
    }
    
    public func isRequiredField(_ required: Bool, with message: String) -> Self {
        model.isRequiredField = required
        model.requiredFieldMessage = message
        return self
    }
}
