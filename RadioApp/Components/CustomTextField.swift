import SwiftUI

// MARK: - CustomTextField
struct CustomTextField: View {
    // MARK: - Properties
    var placeHolder: String
    var isSecure: Bool = false
    @Binding var text: String
    @FocusState var isActive
    
    // MARK: - Drawing Constants
    private struct Drawing {
        static let height: CGFloat = 50
        static let leadingPadding: CGFloat = 16
        static let verticalPadding: CGFloat = 16
        static let horizontalPadding: CGFloat = 16
        static let cornerRadius: CGFloat = 16
        static let strokeWidth: CGFloat = 2.0
        static let strokeOpacity: CGFloat = 0.3
        static let titleFontSize: CGFloat = 18
        static let titleOffsetX: CGFloat = -10
        static let titleOffsetY: CGFloat = -10
        static let borderColor = DS.Colors.pinkNeon
        static let textColor = Color.white
        static let filledBorderColor = DS.Colors.blueLight
        static let backgroundWidth: CGFloat = 100
        static let backgroundHeight: CGFloat = 20
        static let backgroundColor = Color.clear
    }
    
    // MARK: - Body
    var body: some View {
        Group {
            if isSecure {
                SecureField(
                    placeHolder,
                    text: $text
                )
                .padding(.leading, Drawing.leadingPadding)
                .padding(.vertical, Drawing.verticalPadding)
                .focused($isActive)
                
                .frame(height: Drawing.height)
            } else {
                TextField(
                    placeHolder,
                    text: $text
                )
                .padding(.leading, Drawing.leadingPadding)
                .focused($isActive)
                
                .padding(.vertical, Drawing.verticalPadding)
                .frame(height: Drawing.height)
            }
        }
        .autocapitalization(.none)
        .foregroundColor(Drawing.textColor)
        .disableAutocorrection(true)
        .overlay {
            ZStack(alignment: .leading)  {
                RoundedRectangle(cornerRadius: Drawing.cornerRadius)
                    .stroke(
                        text.isEmpty ? Drawing.borderColor : Drawing.filledBorderColor,
                        lineWidth: Drawing.strokeWidth
                    )
                    .opacity(Drawing.strokeOpacity)
                Text(placeHolder)
                    .padding(.horizontal)
                    .offset(y: (isActive || !text.isEmpty) ? -35 : 0)
                    .foregroundStyle(isActive
                                     ? Drawing.borderColor
                                     : .gray
                    )
                    .animation(.spring, value: isActive)
                
            }
        }
    }
}

// MARK: - Preview
#Preview {
    CustomTextField(
        placeHolder: "email", isSecure: true, text: .constant("Value")
    )
}
