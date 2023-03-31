using System;
using System.Runtime.InteropServices;
using UnityEngine;

namespace TextTextureNative
{
    public static class TextTextureNativeManager
    {
        private const string libName = "__Internal";
        
        [DllImport(libName)]
        private static extern long TextTextureNativeManager_addTwo(long src);
        
        [DllImport(libName)]
        private static extern IntPtr TextTextureNativeManager_makeTexture(string config);
        
        [DllImport(libName)]
        private static extern void TextTextureNativeManager_render(string config);
        
        [Serializable]
        class MakeTextureConfig
        {
            public string uuid;
			public int width;
			public int height;
			public int scale;
        }

        [Serializable]
        class RenderConfig
        {
            public string uuid;
			public string text;
			public float size;
			public string color;
        }

        [Serializable]
        class AppEventMonitorEvent
        {
            public string characters;
        }

        public static long AddTwo(long src)
        {
            return TextTextureNativeManager_addTwo(src);
        }

        public static Texture2D MakeTexture(string uuid, int width, int height, int scale)
        {
			var c = new MakeTextureConfig();
			c.uuid = uuid;
			c.width = width;
			c.height = height;
			c.scale = scale;
			var s = JsonUtility.ToJson(c);
			var ptr = TextTextureNativeManager_makeTexture(s);
            return Texture2D.CreateExternalTexture(width, height, TextureFormat.RGBA32, false, false, ptr);
        }

        public static void Render(string uuid, string text, float size, Color color)
        {
			var c = new RenderConfig();
			c.uuid = uuid;
			c.text = text;
			c.size = size;
			c.color = ColorUtility.ToHtmlStringRGBA(color);
			var s = JsonUtility.ToJson(c);
			TextTextureNativeManager_render(s);
        }
    }
}