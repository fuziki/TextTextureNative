using UnityEngine;
using UnityEngine.UI;
#if UNITY_EDITOR
using UnityEditor;
using UnityEditor.UI;
#endif

namespace TextTextureNative
{
    // Beta
	[ExecuteAlways]
	[RequireComponent(typeof(CanvasRenderer))]
	[AddComponentMenu("UTextTextureNative/TextTexture", 100)]
	public class TextTexture : MaskableGraphic
	{
        private string uuid = System.Guid.NewGuid().ToString();

        [TextArea(3, 10)]
        [SerializeField]
        string m_Text = "Text";

        private string latestText = "Text";

        private Texture texture = null;

        public override Texture mainTexture
        {
            get
            {
                if (texture != null) return texture;
                return base.mainTexture;
            }
        }

#if UNITY_EDITOR
        protected override void OnValidate()
        {
            if (texture == null)
                texture = TextTextureNativeManager.MakeTexture(uuid, 512, 512);
            TextTextureNativeManager.Render(uuid, m_Text, 24, Color.red, 2);
        }
#endif

        private void Update()
        {
#if !UNITY_EDITOR
            if (latestText != m_Text)
            {
                if (texture == null)
                    texture = TextTextureNativeManager.MakeTexture(uuid, 512, 512);
                TextTextureNativeManager.Render(uuid, m_Text, 24, Color.red, 2);
                latestText = m_Text;
            }
#endif
        }

        protected override void OnPopulateMesh(VertexHelper vh)
        {
            var r = GetPixelAdjustedRect();
            var v = new Vector4(r.x, r.y, r.x + r.width, r.y + r.height);
            Color32 color32 = color;
            vh.Clear();
            vh.AddVert(new Vector3(v.x, v.y), color32, new Vector2(0, 0));
            vh.AddVert(new Vector3(v.x, v.w), color32, new Vector2(0, 1));
            vh.AddVert(new Vector3(v.z, v.w), color32, new Vector2(1, 1));
            vh.AddVert(new Vector3(v.z, v.y), color32, new Vector2(1, 0));
            vh.AddTriangle(0, 1, 2);
            vh.AddTriangle(2, 3, 0);
        }
    }

#if UNITY_EDITOR
    [CustomEditor(typeof(TextTexture), true)]
    [CanEditMultipleObjects]
    public class TextTextureEditor : GraphicEditor
    {
        private SerializedProperty m_Text;

        protected override void OnEnable()
        {
            base.OnEnable();

            m_Text = serializedObject.FindProperty("m_Text");
        }

        public override void OnInspectorGUI()
        {
            serializedObject.Update();
            EditorGUILayout.PropertyField(m_Text);
            serializedObject.ApplyModifiedProperties();
        }
    }
#endif
}