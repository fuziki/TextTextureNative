using UnityEngine;
using UnityEngine.UI;
using TextTextureNative;

public class Cube : MonoBehaviour
{

    public Image image;
    private string uuid = "hoge";

    private int count = 0;
    
    // Start is called before the first frame update
    void Start()
    {
        Debug.Log("Start!!");
        var texture = TextTextureNativeManager.MakeTexture(uuid, 256, 256, 2);
        
        TextTextureNativeManager.Render(uuid, "𩸽ちゃん", 32, Color.white);
        
        Renderer m_Renderer = GetComponent<Renderer>();
        m_Renderer.material.SetTexture("_MainTex", texture);
        
        image.sprite = Sprite.Create(texture, new Rect(0, 0, texture.width, texture.height), Vector2.zero);
    }

    void Update()
    {
        count = (count + 1) % 100;
        
        TextTextureNativeManager.Render(uuid, $"𩸽ちゃん{count}", 32, Color.white);
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