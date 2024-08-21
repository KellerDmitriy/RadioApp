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
        static let cornerRadius: CGFloat = 16
        static let strokeWidth: CGFloat = 2.0
        static let strokeOpacity: CGFloat = 0.3
        static let borderColor = DS.Colors.pinkNeon
        static let textColor = Color.white
        static let filledBorderColor = DS.Colors.blueLight
    }
    
    // MARK: - Body
    var body: some View {
        ZStack(alignment: .leading) {
            // Placeholder Text
            Text(placeHolder)
                .foregroundColor(isActive || !text.isEmpty ? Drawing.filledBorderColor : .gray)
                .padding(.horizontal, Drawing.leadingPadding)
                .background(Color.clear)
                .offset(x: 0, y: (isActive || !text.isEmpty) ? -25 : 0)
                .scaleEffect(isActive || !text.isEmpty ? 0.8 : 1.0, anchor: .leading)
                .animation(.spring(response: 0.3, dampingFraction: 0.5), value: isActive || !text.isEmpty)
            
            // Text Field or Secure Field
            if isSecure {
                SecureField("", text: $text)
                    .padding(.leading, Drawing.leadingPadding)
                    .padding(.top, Drawing.verticalPadding)
                    .focused($isActive)
                    .frame(height: Drawing.height)
                    .foregroundColor(Drawing.textColor)
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
            } else {
                TextField("", text: $text)
                    .padding(.leading, Drawing.leadingPadding)
                    .padding(.top, Drawing.verticalPadding)
                    .focused($isActive)
                    .frame(height: Drawing.height)
                    .foregroundColor(Drawing.textColor)
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
            }
        }
        .padding(.vertical, Drawing.verticalPadding / 2)
        .overlay(
            RoundedRectangle(cornerRadius: Drawing.cornerRadius)
                .stroke(isActive || !text.isEmpty ? Drawing.filledBorderColor : Drawing.borderColor, lineWidth: Drawing.strokeWidth)
                .opacity(Drawing.strokeOpacity)
        )
        .onTapGesture {
            isActive = true
        }
    }
}

// MARK: - Preview
#Preview {
    CustomTextField(
        placeHolder: "email",
        isSecure: false,
        text: .constant("")
    )
}
