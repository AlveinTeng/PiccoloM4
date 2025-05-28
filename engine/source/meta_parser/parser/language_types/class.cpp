#include "common/precompiled.h"

#include "class.h"

BaseClass::BaseClass(const Cursor& cursor) : name(Utils::getTypeNameWithoutNamespace(cursor.getType())) {}

Class::Class(const Cursor& cursor, const Namespace& current_namespace) :
    TypeInfo(cursor, current_namespace), m_name(cursor.getDisplayName()),
    m_qualified_name(Utils::getTypeNameWithoutNamespace(cursor.getType())),
    m_display_name(Utils::getNameWithoutFirstM(m_qualified_name))
{
    // std::cout << "CLASS" << std::endl;
    if (m_name == "BoneBlendWeight") {
        std::cout << "[CLASS], the type of blend_clip_file_length is " << m_qualified_name << std::endl;
    }
    Utils::replaceAll(m_name, " ", "");
    Utils::replaceAll(m_name, "Piccolo::", "");

    for (auto& child : cursor.getChildren())
    {
        switch (child.getKind())
        {
            case CXCursor_CXXBaseSpecifier: {
                auto base_class = new BaseClass(child);

                m_base_classes.emplace_back(base_class);
            }
            break;
            // field
            
            case CXCursor_FieldDecl:
                
                m_fields.emplace_back(new Field(child, current_namespace, this));
                if (m_name == "BoneBlendWeight") {
                    std::cout << "[CLASS], " << m_fields.back()->m_name << "has type " << m_fields.back()->m_type << std::endl;
                }
                break;
            // method
            case CXCursor_CXXMethod:
                m_methods.emplace_back(new Method(child, current_namespace, this));
            default:
                break;
        }
    }
}

bool Class::shouldCompile(void) const { return shouldCompileFields()|| shouldCompileMethods(); }

bool Class::shouldCompileFields(void) const
{
    return m_meta_data.getFlag(NativeProperty::All) || m_meta_data.getFlag(NativeProperty::Fields) ||
           m_meta_data.getFlag(NativeProperty::WhiteListFields);
}

bool Class::shouldCompileMethods(void) const{
    
    return m_meta_data.getFlag(NativeProperty::All) || m_meta_data.getFlag(NativeProperty::Methods) ||
           m_meta_data.getFlag(NativeProperty::WhiteListMethods);
}

std::string Class::getClassName(void) { return m_name; }

bool Class::isAccessible(void) const { return m_enabled; }