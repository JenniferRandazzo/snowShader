using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SnowUI : MonoBehaviour
{
    Renderer rend;
    [Range(0f, 1f)]
    public float changeSnowAmout;
    public float falloff;
    

    // Start is called before the first frame update
    void Start()
    {
        rend = GetComponent<Renderer>();
    }

    // Update is called once per frame
    void Update()
    {
        if (falloff < 0.5)
        {
            rend.material.SetVector("_SnowDirection", new Vector4(1, 0, 0, 0));
        } else
        {
            rend.material.SetVector("_SnowDirection", new Vector4(0, 1, 0, 0));
        }

        rend.material.SetFloat("_SnowAmount", changeSnowAmout);
        
    }
}
