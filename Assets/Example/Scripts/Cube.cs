using UnityEngine;
using UnityEngine.UI;
using TextTextureNative;

public class Cube : MonoBehaviour
{

    public Image image;
    public Text text;

    private string uuid = "hoge";

    private int count = 0;
    
    // Start is called before the first frame update
    void Start()
    {
        Debug.Log("Start!!");

        var texture = TextTextureNativeManager.MakeTexture(uuid, 512, 512, 2);
        
        Renderer m_Renderer = GetComponent<Renderer>();
        m_Renderer.material.SetTexture("_MainTex", texture);
        
        image.sprite = Sprite.Create(texture, new Rect(0, 0, texture.width, texture.height), Vector2.zero);
    }

    void Update()
    {
        count = (count + 1) % 100;

        var str = $"𝕳𝖊𝖑𝖑𝖔𝖂𝖔𝖗𝖑𝖉\n𝓗𝓮𝓵𝓵𝓸𝓦𝓸𝓻𝓵𝓭\n🐙🪼🫚{count}";

        text.text = str;

        TextTextureNativeManager.Render(uuid, str, 24, Color.white);
    }

    void OnDestroy()
    {
        Debug.Log("Stop!!");
    }

    private void OnKeyDown(string key)
    {
        Debug.Log($"OnKeyDown: {key}");
    }
}