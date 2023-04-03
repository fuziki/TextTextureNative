using System;
using System.Runtime.InteropServices;
using UnityEngine;

namespace TextTextureNative
{
    public static class TextTextureNativeManager
    {
#if UNITY_EDITOR_OSX || UNITY_IOS
        [Serializable]
        private class MakeTextureConfig
        {
            public string uuid;
            public int width;
            public int height;
        }

        [Serializable]
        private class RenderConfig
        {
            public string uuid;
            public string text;
            public float size;
            public string color;
            public int scale;
        }

#if !UNITY_EDITOR_OSX
        private const string libName = "__Internal";
#else
        private const string libName = "TextTextureNative-macOS";
#endif
        [DllImport(libName)]
        private static extern long TextTextureNativeManager_addTwo(long src);

        [DllImport(libName)]
        private static extern IntPtr TextTextureNativeManager_makeTexture(string config);

        [DllImport(libName)]
        private static extern void TextTextureNativeManager_render(string config);

        public static Texture2D MakeTexture(string uuid, int width, int height)
        {
            var c = new MakeTextureConfig();
            c.uuid = uuid;
            c.width = width;
            c.height = height;
            var s = JsonUtility.ToJson(c);
            var ptr = TextTextureNativeManager_makeTexture(s);
            return Texture2D.CreateExternalTexture(width, height, TextureFormat.RGBA32, false, false, ptr);
        }

        public static void Render(string uuid, string text, float size, Color color, int scale)
        {
            var c = new RenderConfig();
            c.uuid = uuid;
            c.text = text;
            c.size = size;
            c.color = ColorUtility.ToHtmlStringRGBA(color);
            c.scale = scale;
            var s = JsonUtility.ToJson(c);
            TextTextureNativeManager_render(s);
        }
#else
        public static Texture2D MakeTexture(string uuid, int width, int height)
        {
            return new Texture2D(width, height);
        }

        public static void Render(string uuid, string text, float size, Color color, int scale)
        {
        }
#endif
    }
}
